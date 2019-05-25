require "dotpretty/color_palettes/bash"
require "dotpretty/color_palettes/null"
require "dotpretty/options"
require "dotpretty/reporters/factory"
require "stringio"

describe Dotpretty::Options do

  describe "Building options" do
    it "has a basic reporter" do
      reporter_name = Dotpretty::Reporters::Names::BASIC

      options = Dotpretty::Options.build({
        color: false,
        output: StringIO.new,
        reporter_name: reporter_name
      })

      expect(options.reporter).to be_kind_of(Dotpretty::Reporters::Basic)
    end

    it "has a basic reporter with color" do
      reporter_name = Dotpretty::Reporters::Names::BASIC
      output = StringIO.new

      expect(Dotpretty::Reporters::Factory).to receive(:build_reporter).with(reporter_name, {
        color_palette: Dotpretty::ColorPalettes::Bash,
        output: output
      })

      Dotpretty::Options.build({
        color: true,
        output: output,
        reporter_name: reporter_name
      }).reporter
    end

    it "has a basic reporter with no color" do
      reporter_name = Dotpretty::Reporters::Names::BASIC
      output = StringIO.new

      expect(Dotpretty::Reporters::Factory).to receive(:build_reporter).with(reporter_name, {
        color_palette: Dotpretty::ColorPalettes::Null,
        output: output
      })

      Dotpretty::Options.build({
        color: false,
        output: output,
        reporter_name: reporter_name
      }).reporter
    end
  end

end
