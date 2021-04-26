module Invaders
  module Renders
    class CleanRadarRender < Base
      attr_reader :new_radar
      private :new_radar

      def call
        @new_radar = Array.new(radar.height) { Array.new(radar.width) { blank_character } }

        summary = []
        matches.sort { |a, b| a[:y] <=> b[:y] }.each do |match|
          update_new_radar(match)
          summary << "Invader x: #{match[:x]}, y: #{match[:y]}, accuracy: #{(match[:accuracy] * 100).round(2)}%"
        end

        [
          new_radar.map(&:join).join("\n"),
          summary.join("\n")
        ]
      end

      private

      def update_new_radar(match)
        x_start = match[:x]
        y_start = match[:y]

        match[:invader].each_with_index do |invader_row, y|
          invader_row.each_with_index do |invader_value, x|
            next if (y_start + y) >= radar.height || (x_start + x) >= radar.width
            next if @new_radar[y_start + y][x_start + x] != blank_character

            value = if invader_value
              radar.value_at(y_start + y, x_start + x) == invader_value ? object_character : unmatched_object_character
            else
              radar.value_at(y_start + y, x_start + x) == invader_value ? blank_character : unmatched_blank_character
            end

            @new_radar[y_start + y][x_start + x] = value
          end
        end
      end

      def object_character
        mapper::OBJECT_CHAR
      end

      def unmatched_object_character
        show_unmatches? ? mapper::UNMATCHED_OBJECT_CHAR : mapper::OBJECT_CHAR
      end

      def blank_character
        mapper::BLANK_CHAR
      end

      def unmatched_blank_character
        show_unmatches? ? mapper::UNMATCHED_BLANK_CHAR : mapper::BLANK_CHAR
      end

      def mapper
        options[:mapper]
      end

      def show_unmatches?
        options.fetch(:show_unmatches, false)
      end
    end
  end
end
