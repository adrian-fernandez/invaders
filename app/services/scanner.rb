module Invaders
  module Services
    class Scanner
      DEFAULT_TOLERANCE = 0.8
      DEFAULT_MIN_INVADER_SIZE = 0.35

      attr_reader :radar, :invaders, :tolerance, :min_invader_size, :matches
      private :tolerance, :min_invader_size

      def initialize(radar:, invaders:, tolerance: DEFAULT_TOLERANCE, min_invader_size: DEFAULT_MIN_INVADER_SIZE)
        @radar = radar
        @invaders = invaders
        @tolerance = tolerance
        @min_invader_size = min_invader_size
      end

      def call
        local_matches = []
        invaders.each do |invader|
          search_invader(invader) do |result, x, y|
            if acceptable_result?(result, invader)
              local_matches << build_result(result, x, y, invader)
            end
          end
        end

        @matches = sort_matches_by_accuracy(local_matches)
      end

      private

      def search_invader(invader, &block)
        initial_y = 0
        initial_x = 0

        y = initial_y
        while (y < radar.height) do
          x = initial_x
          while (x < radar.width) do
            search_invader_pos(invader, x, y, &block)

            x += 1
          end

          y += 1
        end
      end

      def search_invader_pos(invader, x, y, &block)
        if x < invader.width || y < invader.height || invader.width + x >= radar.width || invader.height + y >= radar.height
          subinvader = invader.subinvader(radar, x, y)
          subradar = radar.subimage(x, y, subinvader.width, subinvader.height)
          yield(subradar.compare(subinvader), x, y)
        end

        if invader.width + x < radar.width && invader.height + y < radar.height
          subradar = radar.subimage(x, y, invader.width, invader.height)
          yield(subradar.compare(invader), x, y)
        end
      end

      def acceptable_result?(result, invader)
        invader_size = invader.width * invader.height
        result.fetch(:accuracy, 0.0) >= tolerance && result.fetch(:total_size) >= invader_size * min_invader_size
      end

      def build_result(result, x, y, invader)
        {
          x: x,
          y: y,
          total_size: result.fetch(:total_size),
          matches_count: result.fetch(:matches_count),
          accuracy: result.fetch(:accuracy, 0.0),
          invader: invader
        }
      end

      def sort_matches_by_accuracy(matches)
        matches.sort { |x, y| y[:accuracy] <=> x[:accuracy] }
      end
    end
  end
end
