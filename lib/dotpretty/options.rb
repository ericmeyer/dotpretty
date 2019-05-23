require "dotpretty/color_palettes/bash"
require "dotpretty/color_palettes/null"
require "dotpretty/http/client"
require "dotpretty/http/null_client"
require "dotpretty/reporters/factory"

module Dotpretty
  class Options

    def self.build(command_line_args)
      color_palette = command_line_args[:color] ? Dotpretty::ColorPalettes::Bash : Dotpretty::ColorPalettes::Null
      http_client = Dotpretty::Http::Client.new({
        api_root: "http://localhost:4567"
      })
      reporter_name = command_line_args.fetch(:reporter_name)
      return Dotpretty::Options.new({
        color_palette: color_palette,
        http_client: http_client,
        output: command_line_args.fetch(:output),
        reporter_name: reporter_name
      })
    end

    def initialize(color_palette:, http_client: Dotpretty::Http::NullClient.new, output:, reporter_name:)
      self.color_palette = color_palette
      self.http_client = http_client
      self.output = output
      self.reporter_name = reporter_name
    end

    def reporter
      return Dotpretty::Reporters::Factory.build_reporter(reporter_name, {
        color_palette: color_palette,
        http_client: http_client,
        output: output
      })

    end

    private

    attr_accessor :color_palette, :http_client, :output, :reporter_name

  end
end
