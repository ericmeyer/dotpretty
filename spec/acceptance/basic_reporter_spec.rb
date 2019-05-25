require "acceptance/fixtures"
require "acceptance/scenarios"
require "dotpretty/options"
require "dotpretty/runner"
require "dotpretty/reporters/factory"
require "dotpretty/reporters/names"
require "fakes/color_palette"
require "stringio"

describe "The basic reporter" do

  def parse_input(filename, options = {})
    output = StringIO.new
    color_palette = options[:color] ? Fakes::ColorPalette : Dotpretty::ColorPalettes::Null
    options = Dotpretty::Options.new({
      color_palette: color_palette,
      output: output,
      reporter_name: Dotpretty::Reporters::Names::BASIC
    })
    runner = Dotpretty::Runner.new({ reporter: options.reporter })
    Fixtures.each_line(filename) { |line| runner.input_received(line) }
    runner.done_with_input
    return output.string
  end

  Dotpretty::AcceptanceTestScenarios::ALL.each do |scenario|
    it "parses a test suite with #{scenario[:description]}" do
      actual_output = parse_input("dotnet_input/#{scenario[:filename]}.log", color: scenario[:color])
      output_filename = scenario[:filename]
      output_filename += "_with_color" if scenario[:color]
      expected_output = Fixtures.read("basic_reporter_output/#{output_filename}.log")
      expect(actual_output).to eq(expected_output)
    end
  end

end
