require "dotpretty/color_palettes/bash"
require "dotpretty/color_palettes/null"
require "dotpretty/reporters/factory"

module Dotpretty
  class Options

    def self.build(command_line_args)
      return Dotpretty::Options.new({
        color: command_line_args.fetch(:color),
        output: command_line_args.fetch(:output),
        reporter_name: command_line_args.fetch(:reporter_name)
      })
    end

    def initialize(color:, output:, reporter_name:)
      self.color = color
      self.output = output
      self.reporter_name = reporter_name
    end

    def reporter
      return Dotpretty::Reporters::Factory.build_reporter(reporter_name, {
        color: color,
        output: output
      })
    end

    private

    attr_accessor :color, :output, :reporter_name

  end
end
