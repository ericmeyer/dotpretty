require "dotpretty/color_palettes/null"
require "dotpretty/reporters/basic"
require "dotpretty/reporters/json"
require "dotpretty/reporters/names"
require "dotpretty/reporters/progress"

module Dotpretty
  module Reporters
    class Factory

      def self.build_reporter(name, options = {})
        factory = self.new(color_palette: options.fetch(:color_palette), output: options.fetch(:output))
        return factory.build_reporter(name)
      end

      def initialize(color_palette:, output:)
        self.color_palette = color_palette
        self.output = output
      end

      def build_reporter(color: false, name:)
        case name
        when Dotpretty::Reporters::Names::JSON
          return Dotpretty::Reporters::Json.new(output)
        when Dotpretty::Reporters::Names::PROGRESS
          return Dotpretty::Reporters::Progress.new({
            color_palette: choose_color_palette(color),
            output: output
          })
        else
          return Dotpretty::Reporters::Basic.new({
            color_palette: choose_color_palette(color),
            output: output
          })
        end
      end

      private

      def choose_color_palette(color)
        color ? color_palette : Dotpretty::ColorPalettes::Null
      end

      attr_accessor :color_palette, :output

    end
  end
end
