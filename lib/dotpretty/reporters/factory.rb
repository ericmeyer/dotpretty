require "dotpretty/reporters/basic"
require "dotpretty/reporters/json"
require "dotpretty/reporters/names"
require "dotpretty/reporters/progress"

module Dotpretty
  module Reporters
    class Factory

      def self.build_reporter(name, output)
        case name
        when Dotpretty::Reporters::Names::JSON
          return Dotpretty::Reporters::Json.new(output)
        when Dotpretty::Reporters::Names::PROGRESS
          return Dotpretty::Reporters::Progress.new(output)
        else
          return Dotpretty::Reporters::Basic.new(output)
        end
      end

    end
  end
end
