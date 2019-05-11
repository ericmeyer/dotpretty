require "dotpretty/runner"
require "dotpretty/reporters/names"
require "dotpretty/parser"
require "dotpretty/reporters/factory"
require "stringio"
require "acceptance/fixtures"
require "fakes/colorer"

describe "Parsing test output" do

  def parse_input(filename, options = {})
    output = StringIO.new
    colorer = options[:color] ? Fakes::Colorer : Dotpretty::Colorers::Null
    runner = Dotpretty::Runner.new({
      colorer: colorer,
      output: output,
      reporter_name: Dotpretty::Reporters::Names::BASIC
    })
    Fixtures.each_line(filename) { |line| runner.parse_line(line) }
    return output.string
  end

  it "parses a test suite with one passing test" do
    actual_output = parse_input("dotnet_input/single_passing_test.log")
    expected_output = Fixtures.read("basic_reporter_output/single_passing_test.log")
    expect(actual_output).to eq(expected_output)
  end

  it "parses a test suite with one passing and one failing test" do
    actual_output = parse_input("dotnet_input/single_failing_test.log")
    expected_output = Fixtures.read("basic_reporter_output/single_failing_test.log")
    expect(actual_output).to eq(expected_output)
  end

  it "parses a test suite with one passing and one failing test with color" do
    actual_output = parse_input("dotnet_input/single_failing_test.log", { color: true })
    expected_output = Fixtures.read("basic_reporter_output/single_failing_test_with_color.log")
    expect(actual_output).to eq(expected_output)
  end

  it "parses a test suite with the last test failing" do
    actual_output = parse_input("dotnet_input/last_test_failing.log")
    expected_output = Fixtures.read("basic_reporter_output/last_test_failing.log")
    expect(actual_output).to eq(expected_output)
  end

end
