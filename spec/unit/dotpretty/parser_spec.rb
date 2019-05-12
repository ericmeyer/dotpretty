require "dotpretty/colorers/null"
require "dotpretty/parser"
require "dotpretty/reporters/basic"
require "stringio"

describe Dotpretty::Parser do

  def build_parser(output)
    return Dotpretty::Parser.new({
      reporter: Dotpretty::Reporters::Basic.new({
        colorer: Dotpretty::Colorers::Null,
        output: output
      })
    })
  end

  describe "Parsing input" do
    it "starts with no output" do
      output = StringIO.new
      parser = build_parser(output)

      expect(output.string).to eq("")
    end

    it "notifies when the build has started" do
      output = StringIO.new
      parser = build_parser(output)

      parser.parse_line("Build started 4/17/19 8:22:32 PM.")

      expect(output.string).to eq("Build started\n")
    end

    it "ignores build output" do
      output = StringIO.new
      parser = build_parser(output)
      parser.parse_line("Build started 4/17/19 8:22:32 PM.")
      output.truncate(0)

      parser.parse_line("     1>Project \"/path/to/workspace/SampleSolution/SampleProjectTests/SampleProjectTests.csproj\" on node 1 (Restore target(s)).")

      expect(output.string).to eq("")
    end

    it "notifies when the build has completed" do
      output = StringIO.new
      parser = build_parser(output)
      parser.parse_line("Build started 4/17/19 8:22:32 PM.")
      output.truncate(0)
      output.rewind

      parser.parse_line("Build completed.")

      expect(output.string).to eq("Build completed\n\n")
    end

    it "starts the test run when the build has completed" do
      output = StringIO.new
      parser = build_parser(output)
      parser.parse_line("Build started 4/17/19 8:22:32 PM.")
      parser.parse_line("Build completed")
      output.truncate(0)
      output.rewind

      parser.parse_line("Starting test execution, please wait...")

      expect(output.string).to eq("Starting test execution...\n")
    end

    context "when running tests" do
      it "shows a passing test" do
        output = StringIO.new
        parser = build_parser(output)
        parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        parser.parse_line("Build completed")
        parser.parse_line("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        parser.parse_line("Passed   SampleProjectTests.UnitTest1.Test1")

        expect(output.string).to eq("Passed   SampleProjectTests.UnitTest1.Test1\n")
      end

      it "shows a second passing test" do
        output = StringIO.new
        parser = build_parser(output)
        parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        parser.parse_line("Build completed")
        parser.parse_line("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        parser.parse_line("Passed   SampleProjectTests.UnitTest1.Test1")
        parser.parse_line("Passed   SampleProjectTests.UnitTest1.Test2")

        expect(output.string).to eq("Passed   SampleProjectTests.UnitTest1.Test1\nPassed   SampleProjectTests.UnitTest1.Test2\n")
      end

      it "ignores startup output" do
        output = StringIO.new
        parser = build_parser(output)
        parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        parser.parse_line("Build completed")
        parser.parse_line("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        parser.parse_line("[xUnit.net 00:00:00.55]   Discovering: SampleProjectTests")
        parser.parse_line("Passed   SampleProjectTests.UnitTest1.Test1")

        expect(output.string).to eq("Passed   SampleProjectTests.UnitTest1.Test1\n")
      end
    end

    context "when reading a test failure" do
      before(:each) do
        @output = StringIO.new
        @parser = build_parser(@output)
        @parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        @parser.parse_line("Build completed")
        @parser.parse_line("Starting test execution, please wait...")
        @output.truncate(0)
        @output.rewind
      end

      it "shows a failing test" do
        @parser.parse_line("Failed   SampleProjectTests.UnitTest1.Test2")
        @parser.parse_line("Passed SomeTest")

        expect(@output.string).to eq("Failed   SampleProjectTests.UnitTest1.Test2\nPassed   SomeTest\n")
      end

      it "shows the failure details" do
        @parser.parse_line("Failed   SampleProjectTests.UnitTest1.Test2")
        @parser.parse_line("Other info")
        @parser.parse_line("Passed SomeTest")

        expect(@output.string).to eq("Failed   SampleProjectTests.UnitTest1.Test2\nOther info\nPassed   SomeTest\n")
      end

      it "stops parsing the failure when it encounters a passing test" do
        @parser.parse_line("Failed   SampleProjectTests.UnitTest1.Test2")
        @parser.parse_line("Other info")
        @parser.parse_line("Passed SomeTest")
        @output.truncate(0)
        @output.rewind

        @parser.parse_line("Some info")

        expect(@output.string).to eq("")
      end

      it "stops parsing the failure when it encounters the test summary" do
        @parser.parse_line("Failed   SampleProjectTests.UnitTest1.Test2")
        @parser.parse_line("Other info")
        @parser.parse_line("Total tests: 1. Passed: 1. Failed: 0. Skipped: 0.")
        @output.truncate(0)
        @output.rewind

        @parser.parse_line("Some info")

        expect(@output.string).to eq("")
      end

      it "outputs the test summary" do
        @parser.parse_line("Failed   SampleProjectTests.UnitTest1.Test2")
        @parser.parse_line("Other info")

        @parser.parse_line("Total tests: 1. Passed: 1. Failed: 0. Skipped: 0.")

        expect(@output.string).to eq("Failed   SampleProjectTests.UnitTest1.Test2\nOther info\n\nTotal tests: 1. Passed: 1. Failed: 0. Skipped: 0.\n")
      end
    end

    context "when the tests finish" do
      it "shows the test summary" do
        output = StringIO.new
        parser = build_parser(output)
        parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        parser.parse_line("Build completed")
        parser.parse_line("Starting test execution, please wait...")
        parser.parse_line("Passed   SampleProjectTests.UnitTest1.Test1")
        output.truncate(0)
        output.rewind

        parser.parse_line("Total tests: 1. Passed: 1. Failed: 0. Skipped: 0.")

        expect(output.string).to eq("\nTotal tests: 1. Passed: 1. Failed: 0. Skipped: 0.\n")
      end
    end

    context "when the build fails" do
      it "outputs build failure with no details" do
        output = StringIO.new
        parser = build_parser(output)
        parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        output.truncate(0)
        output.rewind

        parser.parse_line("Build FAILED.")
        parser.done_with_input

        expect(output.string).to eq("Build failed\n")
      end

      it "outputs build failure with details" do
        output = StringIO.new
        parser = build_parser(output)
        parser.parse_line("Build started 4/17/19 8:22:32 PM.")
        output.truncate(0)
        output.rewind

        parser.parse_line("Build FAILED.")
        parser.parse_line("details1")
        parser.parse_line("details2")
        parser.done_with_input

        expect(output.string).to include("details1")
        expect(output.string).to include("details2")
      end
    end
  end

end
