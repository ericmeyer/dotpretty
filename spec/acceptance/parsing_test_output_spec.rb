require "dotpretty/parser"
require "stringio"
require "acceptance/fixtures"

describe "Parsing test output" do

  def parse_input(filename)
    output = StringIO.new
    parser = Dotpretty::Parser.new({
      reporter: Dotpretty::Reporters::Basic.new({ output: output })
    })

    Fixtures.each_line(filename) do |line|
      parser.parse_line(line)
    end
    return output.string
  end

  it "parses a test suite with one passing test" do
    actual_output = parse_input("single_passing_test-IN.log")
    expected_output = Fixtures.read("single_passing_test-OUT.log")
    expect(actual_output).to eq(expected_output)
  end

  it "parses a test suite with one passing and one failing test" do
    actual_output = parse_input("single_failing_test-IN.log")
    expected_output = Fixtures.read("single_failing_test-OUT.log")
    expect(actual_output).to eq(expected_output)
  end

  it "parses a test suite with the last test failing" do
    actual_output = parse_input("last_test_failing-IN.log")
    expected_output = Fixtures.read("last_test_failing-OUT.log")
    expect(actual_output).to eq(expected_output)
  end

end
