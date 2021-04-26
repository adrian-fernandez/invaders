require_relative "../mappers/default_image_mapper"

module Invaders
  module Models
    class Invader < Image
      def subinvader(radar, x, y)
        return self unless need_subinvader?(radar, x, y)

        invader_x = nil
        invader_y = nil
        invader_width = nil
        invader_height = nil

        invader_x, invader_width = subinvader_horizontal_data(radar, x).values_at(:invader_x, :invader_width)
        invader_y, invader_height = subinvader_vertical_data(radar, y).values_at(:invader_y, :invader_height)

        subimage(invader_x, invader_y, invader_width, invader_height)
      end

      private

      def need_subinvader?(radar, x, y)
        x < (width - 1) || (width + x) > radar.width || y < (height - 1) || (height + y) > radar.height
      end

      def subinvader_horizontal_data(radar, x)
        if x < (width - 1)
          invader_x = width - x - 1
          invader_width = x + 1
        elsif (width + x) > radar.width
          invader_x = 0
          diff = radar.width - x
          invader_width = x >= width ? diff : x
        else
          invader_x = 0
          invader_width = width
        end

        {
          invader_x: invader_x,
          invader_width: invader_width
        }
      end

      def subinvader_vertical_data(radar, y)
        if y < (height - 1)
          invader_y = height - y - 1
          invader_height = y + 1
        elsif (height + y) > radar.height
          invader_y = 0
          diff = radar.height - y
          invader_height = y >= height ? diff : y
        else
          invader_y = 0
          invader_height = height
        end

        {
          invader_y: invader_y,
          invader_height: invader_height
        }
      end
    end
  end
end
