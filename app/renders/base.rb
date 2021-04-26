module Invaders
  module Renders
    class Base
      attr_reader :radar, :matches, :options

      def initialize(radar, matches, options = {})
        @radar = radar
        @matches = matches
        @options = options
      end

      def call
        raise NotImplementedError.new("Render must implement call method")
      end
    end
  end
end
