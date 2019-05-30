require "acceptance/fixtures"
require "acceptance/scenarios"
require "dotpretty/reporters/names"
require "dotpretty/runner"
require "stringio"

describe "The basic reporter" do

  def parse_input(filename, options = {})
    output = StringIO.new
    reporter = reporter_factory({ output: output }).build_reporter({
      color: options[:color],
      name: Dotpretty::Reporters::Names::BASIC
    })
    runner = Dotpretty::Runner.new({ reporter: reporter })
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
