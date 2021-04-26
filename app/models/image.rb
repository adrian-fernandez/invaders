require_relative "../mappers/default_image_mapper"
require_relative "../services/image_parser"

module Invaders
  module Models
    class Image
      DEFAULT_IMAGE_MAPPER = ::Invaders::Mappers::DefaultImageMapper

      attr_reader :image

      def initialize(image)
        ensure_valid_image!(image)

        @image = image
      end

      def self.parse(raw_image, image_mapper: DEFAULT_IMAGE_MAPPER)
        self.new(::Invaders::Services::ImageParser.new(raw_image, image_mapper: image_mapper).call)
      end

      def each_with_index
        image.each_with_index do |element, index|
          yield(element, index)
        end
      end

      def subimage(x_init, y_init, sub_width, sub_height)
        raise ImageError.new(ImageError::INVALID_COORDINATES) if invalid_coordinates?(x_init, y_init, sub_width, sub_height)

        x_end, y_end = [x_init + sub_width, y_init + sub_height]

        subimage_data = image[y_init...y_end].map { |image_row| image_row[x_init...x_end] }

        Image.new(subimage_data)
      end

      def value_at(y, x)
        image[y][x]
      end

      def compare(other_image)
        image_flatten = linear_image
        other_image_flatten = other_image.linear_image

        raise ImageError.new(ImageError::INVALID_IMAGE_COMPARE_SIZE + "#{image_flatten.size} - #{other_image_flatten.size}") if image_flatten.size != other_image_flatten.size

        matches_count = image_flatten.map.with_index {|character, i| (character == other_image_flatten[i]) }.count(true)
        total_size = image_flatten.size

        {
          matches_count: matches_count,
          total_size: total_size,
          accuracy: matches_count.to_f / total_size.to_f
        }
      end

      def to_s
        image.inspect
      end

      def width
        image.first&.size || 0
      end

      def height
        image.size
      end

      def linear_image
        image.flatten
      end

      private

      def invalid_coordinates?(x_init, y_init, sub_width, sub_height)
        x_init < 0 || y_init < 0 || (x_init + sub_width > width) || (y_init + sub_height > height)
      end

      def ensure_valid_image!(image)
        raise ImageError.new(ImageError::INVALID_IMAGE_DATA) unless image.is_a?(Array)
        raise ImageError.new(ImageError::INVALID_IMAGE_ROW_SIZE + "(#{image.map(&:size).uniq.join(', ')})") if image.map(&:size).uniq.size > 1
      end
    end
  end
end
