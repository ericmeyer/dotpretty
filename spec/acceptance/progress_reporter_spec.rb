require "dotpretty/runner"
require "dotpretty/reporters/names"
require "stringio"
require "acceptance/fixtures"
require "fakes/colorer"

describe "Progress reporter" do

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

  context "when the build is successful" do
    it "parses a test suite with one passing test" do
      actual_output = parse_input("dotnet_input/single_passing_test.log")
      expected_output = Fixtures.read("progress_reporter_output/single_passing_test.log")
      expect(actual_output).to eq(expected_output)
    end

    it "parses a test suite with one passing and one failing test" do
      actual_output = parse_input("dotnet_input/single_failing_test.log")
      expected_output = Fixtures.read("progress_reporter_output/single_failing_test.log")
      expect(actual_output).to eq(expected_output)
    end

    it "parses a test suite with one passing and one failing test with color" do
      actual_output = parse_input("dotnet_input/single_failing_test.log", { color: true })
      expected_output = Fixtures.read("progress_reporter_output/single_failing_test_with_color.log")
      expect(actual_output).to eq(expected_output)
    end

    it "parses a test suite with the last test failing" do
      actual_output = parse_input("dotnet_input/last_test_failing.log")
      expected_output = Fixtures.read("progress_reporter_output/last_test_failing.log")
      expect(actual_output).to eq(expected_output)
    end
  end

  context "when the build fails" do
    it "shows the build failure" do
      actual_output = parse_input("dotnet_input/failing_build.log")
      expected_output = Fixtures.read("progress_reporter_output/failing_build.log")
      expect(actual_output).to eq(expected_output)
    end
  end

end
