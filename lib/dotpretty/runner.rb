require "dotpretty/parser"
require "dotpretty/reporters/factory"

module Dotpretty
  class Runner

    def initialize(colorer:, output:, reporter_name:)
      reporter = Dotpretty::Reporters::Factory.build_reporter(reporter_name, {
        output: output,
        colorer: colorer
      })
      self.parser = Dotpretty::Parser.new({ reporter: reporter })
    end

    def parse_line(line)
      parser.parse_line(line)
    end

    private

    attr_accessor :parser

  end
end
