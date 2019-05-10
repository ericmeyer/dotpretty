require "dotpretty/colorers/null"
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
            colorer: Dotpretty::Colorers::Null,
            output: options.fetch(:output)
          })
        else
          return Dotpretty::Reporters::Basic.new(options.fetch(:output))
        end
      end

    end
  end
end
