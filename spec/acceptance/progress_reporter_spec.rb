require "acceptance/fixtures"
require "acceptance/scenarios"
require "dotpretty/reporters/names"
require "dotpretty/runner"
require "fakes/colorer"
require "stringio"

describe "The progress reporter" do

  def parse_input(filename, options = {})
    output = StringIO.new
    colorer = options[:color] ? Fakes::Colorer : Dotpretty::Colorers::Null
    runner = Dotpretty::Runner.new({
      colorer: colorer,
      output: output,
      reporter_name: Dotpretty::Reporters::Names::PROGRESS
    })
    Fixtures.each_line(filename) { |line| runner.parse_line(line) }
    runner.done_with_input
    return output.string
  end

  Dotpretty::AcceptanceTestScenarios::ALL.each do |scenario|
    it "parses a test suite with #{scenario[:description]}" do
      actual_output = parse_input("dotnet_input/#{scenario[:filename]}.log", color: scenario[:color])
      output_filename = scenario[:filename]
      output_filename += "_with_color" if scenario[:color]
      expected_output = Fixtures.read("progress_reporter_output/#{output_filename}.log")
      expect(actual_output).to eq(expected_output)
    end
  end

end
