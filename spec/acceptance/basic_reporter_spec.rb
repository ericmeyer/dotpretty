require "dotpretty/parser"
require "dotpretty/reporters/factory"
require "stringio"
require "acceptance/fixtures"

describe "Parsing test output" do

  def parse_input(filename)
    output = StringIO.new
    reporter = Dotpretty::Reporters::Factory.build_reporter(Dotpretty::Reporters::Names::BASIC, {
      output: output
    })
    parser = Dotpretty::Parser.new({ reporter: reporter })

    Fixtures.each_line(filename) do |line|
      parser.parse_line(line)
    end
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

  it "parses a test suite with the last test failing" do
    actual_output = parse_input("dotnet_input/last_test_failing.log")
    expected_output = Fixtures.read("basic_reporter_output/last_test_failing.log")
    expect(actual_output).to eq(expected_output)
  end

end
