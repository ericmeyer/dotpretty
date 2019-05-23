require "dotpretty/color_palettes/null"
require "dotpretty/reporters/basic"
require "dotpretty/reporters/json"
require "dotpretty/reporters/names"
require "dotpretty/reporters/progress"

module Dotpretty
  module Reporters
    class Factory

      def self.build_reporter(name, options = {})
        case name
        when Dotpretty::Reporters::Names::JSON
          return Dotpretty::Reporters::Json.new(options.fetch(:output))
        when Dotpretty::Reporters::Names::PROGRESS
          return Dotpretty::Reporters::Progress.new({
            color_palette: options.fetch(:color_palette),
            output: options.fetch(:output)
          })
        else
          return Dotpretty::Reporters::Basic.new({
            color_palette: options.fetch(:color_palette),
            output: options.fetch(:output)
          })
        end
      end

    end
  end
end
