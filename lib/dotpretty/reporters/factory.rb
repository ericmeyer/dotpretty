require "dotpretty/reporters/basic"
require "dotpretty/reporters/json"
require "dotpretty/reporters/names"

module Dotpretty
  module Reporters
    class Factory

      def self.build_reporter(name, output)
        case name
        when Dotpretty::Reporters::Names::JSON
          return Dotpretty::Reporters::Json.new({ output: output })
        else
          return Dotpretty::Reporters::Basic.new({ output: output })
        end
      end

    end
  end
end
