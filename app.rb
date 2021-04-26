require_relative "app/services/scanner"
Dir[File.join(__dir__, "app", "invaders", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "app", "radars", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "app", "errors", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "app", "renders", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "app", "models", "*.rb")].each { |file| require file }

def invaders
  [
    Invaders::Invaders::Invader1.ascii,
    Invaders::Invaders::Invader2.ascii
  ].map { |invader| Invaders::Models::Invader.parse(invader) }
end

def radar
  Invaders::Models::Radar.parse(Invaders::Radars::Radar1.ascii)
end

def output(radar, matches)
  Invaders::Renders::CleanRadarRender.new(
    radar,
    matches,
    mapper: Invaders::Mappers::DefaultImageMapper,
    show_unmatches: false
  ).call
end

scanner = Invaders::Services::Scanner.new(
  radar: radar,
  invaders: invaders
)

scanner.call

puts "RESULT:"
puts output(scanner.radar, scanner.matches)
