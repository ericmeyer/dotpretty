require "dotpretty/parser"
require "stringio"
require "acceptance/fixtures"

describe "Parsing test output" do

  it "parses a test suite with one passing test" do
    output = StringIO.new
    parser = Dotpretty::Parser.new({ output: output })

    Fixtures.each_line("single_passing_test-IN.log") do |line|
      parser.parse_line(line)
    end

    expected_output = Fixtures.read("single_passing_test-OUT.log")
    expect(output.string).to eq(expected_output)
  end

  it "parses a test suite with one passing and one failing test" do
    output = StringIO.new
    parser = Dotpretty::Parser.new({ output: output })

    Fixtures.each_line("single_failing_test-IN.log") do |line|
      parser.parse_line(line)
    end

    expected_output = Fixtures.read("single_failing_test-OUT.log")
    expect(output.string).to eq(expected_output)
  end

end
