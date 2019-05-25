require "dotpretty/color_palettes/bash"
require "dotpretty/color_palettes/null"
require "dotpretty/reporters/factory"

module Dotpretty
  class Options

    def self.build(command_line_args)
      reporter_name = command_line_args.fetch(:reporter_name)
      color_palette = command_line_args[:color] ? Dotpretty::ColorPalettes::Bash : Dotpretty::ColorPalettes::Null
      return Dotpretty::Options.new({
        color_palette: color_palette,
        output: command_line_args.fetch(:output),
        reporter_name: reporter_name
      })
    end

    def initialize(color_palette:, output:, reporter_name:)
      self.color_palette = color_palette
      self.output = output
      self.reporter_name = reporter_name
    end

    def reporter
      return Dotpretty::Reporters::Factory.build_reporter(reporter_name, {
        color_palette: color_palette,
        output: output
      })

    end

    private

    attr_accessor :color_palette, :output, :reporter_name

  end
end
