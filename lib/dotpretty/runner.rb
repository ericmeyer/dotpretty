require "dotpretty/parser"
require "dotpretty/reporters/factory"

module Dotpretty
  class Runner

    def initialize(color_palette:, output:, reporter_name:)
      reporter = Dotpretty::Reporters::Factory.build_reporter(reporter_name, {
        output: output,
        color_palette: color_palette
      })
      self.parser = Dotpretty::Parser.new({ reporter: reporter })
    end

    def parse_line(line)
      parser.parse_line(line)
    end

    def done_with_input
      parser.done_with_input
    end

    private

    attr_accessor :parser

  end
end
