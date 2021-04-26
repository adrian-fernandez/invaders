require_relative "../mappers/default_image_mapper"
require_relative "../models/image"

module Invaders
  module Services
    class ImageParser
      DEFAULT_IMAGE_MAPPER = ::Invaders::Mappers::DefaultImageMapper

      attr_reader :raw_image, :mapper, :image
      private :raw_image, :mapper, :image

      def initialize(raw_image, image_mapper: DEFAULT_IMAGE_MAPPER)
        @raw_image = raw_image
        @mapper = image_mapper
      end

      def call
        parsed_data = raw_image.split(mapper::LINEBREAK_CHAR).compact.reject(&:empty?).map do |image_line|
          image_line.strip.each_char.map do |image_character|
            image_character == mapper::OBJECT_CHAR
          end
        end.compact.reject(&:empty?)

        parsed_data
      end
    end
  end
end
