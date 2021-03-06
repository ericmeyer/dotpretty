require "acceptance/fixtures"
require "dotpretty/runner"
require "dotpretty/reporters/json"
require "json"
require "stringio"

describe "The JSON reporter" do

  def parse_input(filename)
    output = StringIO.new
    reporter = Dotpretty::Reporters::Json.new(output)
    runner = Dotpretty::Runner.new({ reporter: reporter })
    Fixtures.each_line(filename) do |line|
      runner.input_received(line)
    end
    return output.string
  end

  it "parses a test suite with one passing test" do
    raw_output = parse_input("dotnet_input/single_passing_test.log")
    parsed_output = JSON.parse(raw_output)
    expect(parsed_output).to eq({
      "tests" => [{
        "name" => "SampleProjectTests.UnitTest1.Test1",
        "result" => "passed"
      }]
    })
  end

  it "parses a test suite with one failing test" do
    raw_output = parse_input("dotnet_input/one_passing_one_failing.log")
    parsed_output = JSON.parse(raw_output)
    expect(parsed_output).to eq({
      "tests" => [{
        "details" => [
          "Error Message:",
          " Assert.Equal() Failure",
          "Expected: 1",
          "Actual:   2",
          "Stack Trace:",
          "   at SampleProjectTests.UnitTest1.Test2() in /path/to/workspace/SampleSolution/SampleProjectTests/UnitTest1.cs:line 15",
        ],
        "name" => "SampleProjectTests.UnitTest1.Test2",
        "result" => "failed"
      }, {
        "name" => "SampleProjectTests.UnitTest1.Test1",
        "result" => "passed"
      }]
    })
  end

  it "parses a test suite with multiple failing tests" do
    raw_output = parse_input("dotnet_input/last_test_failing.log")
    parsed_output = JSON.parse(raw_output)
    expect(parsed_output).to eq({
      "tests" => [{
        "details" => [
          "Error Message:",
          " Assert.Equal() Failure",
          "Expected: 1",
          "Actual:   2",
          "Stack Trace:",
          "   at SampleProjectTests.UnitTest1.Test2() in /path/to/workspace/SampleSolution/SampleProjectTests/UnitTest1.cs:line 16"
        ],
        "name" => "SampleProjectTests.UnitTest1.Test2",
        "result" => "failed"
      }, {
        "details" => [
          "Error Message:",
          " Assert.Equal() Failure",
          "Expected: 1",
          "Actual:   2",
          "Stack Trace:",
          "   at SampleProjectTests.UnitTest1.Test1() in /path/to/workspace/SampleSolution/SampleProjectTests/UnitTest1.cs:line 10"
        ],
        "name" => "SampleProjectTests.UnitTest1.Test1",
        "result" => "failed"
      }]
    })
  end

  it "parses a test suite with one skipped test" do
    raw_output = parse_input("dotnet_input/single_skipped_test.log")
    parsed_output = JSON.parse(raw_output)
    expect(parsed_output).to eq({
      "tests" => [{
        "name" => "SampleProjectTests.UnitTest1.Test1",
        "result" => "skipped"
      }]
    })
  end

end
