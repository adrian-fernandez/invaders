Dir["./app/**/*.rb"].sort.each { |file| require file }

RSpec.configure do |config|
  config.color = true
end
