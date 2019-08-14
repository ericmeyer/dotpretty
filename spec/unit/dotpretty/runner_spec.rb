require "dotpretty/color_palettes/null"
require "dotpretty/runner"
require "dotpretty/reporters/basic"
require "stringio"

describe Dotpretty::Runner do

  def build_runner(output)
    return Dotpretty::Runner.new({
      reporter: Dotpretty::Reporters::Basic.new({
        color_palette: Dotpretty::ColorPalettes::Null,
        output: output
      })
    })
  end

  describe "Parsing input" do
    it "starts with no output" do
      output = StringIO.new
      runner = build_runner(output)

      expect(output.string).to eq("")
    end

    it "notifies when the build has started" do
      output = StringIO.new
      runner = build_runner(output)

      runner.input_received("Build started 4/17/19 8:22:32 PM.")

      expect(output.string.strip).to eq("Build started")
    end

    it "ignores build output" do
      output = StringIO.new
      runner = build_runner(output)
      runner.input_received("Build started 4/17/19 8:22:32 PM.")
      output.truncate(0)

      runner.input_received("     1>Project \"/path/to/workspace/SampleSolution/SampleProjectTests/SampleProjectTests.csproj\" on node 1 (Restore target(s)).")

      expect(output.string).to eq("")
    end

    it "notifies when the build has completed" do
      output = StringIO.new
      runner = build_runner(output)
      runner.input_received("Build started 4/17/19 8:22:32 PM.")
      output.truncate(0)
      output.rewind

      runner.input_received("Build completed.")

      expect(output.string).to eq("Build completed\n\n")
    end

    it "starts the test run when the build has completed" do
      output = StringIO.new
      runner = build_runner(output)
      runner.input_received("Build started 4/17/19 8:22:32 PM.")
      runner.input_received("Build completed")
      output.truncate(0)
      output.rewind

      runner.input_received("Starting test execution, please wait...")

      expect(output.string.strip).to eq("Starting test execution...")
    end

    context "when running tests" do
      it "shows a passing test" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        runner.input_received("Build completed")
        runner.input_received("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        runner.input_received("Passed   SampleProjectTests.UnitTest1.Test1")

        expect(output.string).to eq("Passed   SampleProjectTests.UnitTest1.Test1\n")
      end

      it "shows a second passing test" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        runner.input_received("Build completed")
        runner.input_received("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        runner.input_received("Passed   SampleProjectTests.UnitTest1.Test1")
        runner.input_received("Passed   SampleProjectTests.UnitTest1.Test2")

        expect(output.string).to eq("Passed   SampleProjectTests.UnitTest1.Test1\nPassed   SampleProjectTests.UnitTest1.Test2\n")
      end

      it "shows a skipped test" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        runner.input_received("Build completed")
        runner.input_received("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        runner.input_received("Skipped  SampleProjectTests.UnitTest1.Test1")

        expect(output.string).to eq("Skipped  SampleProjectTests.UnitTest1.Test1\n")
      end

      it "ignores startup output" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        runner.input_received("Build completed")
        runner.input_received("Starting test execution, please wait...")
        output.truncate(0)
        output.rewind

        runner.input_received("[xUnit.net 00:00:00.55]   Discovering: SampleProjectTests")
        runner.input_received("Passed   SampleProjectTests.UnitTest1.Test1")

        expect(output.string).to eq("Passed   SampleProjectTests.UnitTest1.Test1\n")
      end
    end

    context "when reading a test failure" do
      before(:each) do
        @output = StringIO.new
        @runner = build_runner(@output)
        @runner.input_received("Build started 4/17/19 8:22:32 PM.")
        @runner.input_received("Build completed")
        @runner.input_received("Starting test execution, please wait...")
        @output.truncate(0)
        @output.rewind
      end

      it "shows a failing test" do
        @runner.input_received("Failed   SampleProjectTests.UnitTest1.Test2")
        @runner.input_received("Passed SomeTest")

        expect(@output.string).to eq("Failed   SampleProjectTests.UnitTest1.Test2\n\nPassed   SomeTest\n")
      end

      it "shows the failure details" do
        @runner.input_received("Failed   SampleProjectTests.UnitTest1.Test2")
        @runner.input_received("Other info")
        @runner.input_received("Passed SomeTest")

        expect(@output.string).to eq("Failed   SampleProjectTests.UnitTest1.Test2\nOther info\n\nPassed   SomeTest\n")
      end

      it "stops parsing the failure when it encounters a passing test" do
        @runner.input_received("Failed   SampleProjectTests.UnitTest1.Test2")
        @runner.input_received("Other info")
        @runner.input_received("Passed SomeTest")
        @output.truncate(0)
        @output.rewind

        @runner.input_received("Some info")

        expect(@output.string).to eq("")
      end

      it "stops parsing the failure when it encounters the test summary" do
        @runner.input_received("Failed   SampleProjectTests.UnitTest1.Test2")
        @runner.input_received("Other info")
        @runner.input_received("Total tests: 1. Passed: 1. Failed: 0. Skipped: 0.")
        @output.truncate(0)
        @output.rewind

        @runner.input_received("Some info")

        expect(@output.string).to eq("")
      end

      it "outputs the test summary" do
        @runner.input_received("Failed   SampleProjectTests.UnitTest1.Test2")
        @runner.input_received("Other info")

        @runner.input_received("Total tests: 1. Passed: 1. Failed: 0. Skipped: 0.")

        expect(@output.string).to eq("Failed   SampleProjectTests.UnitTest1.Test2\nOther info\n\n\nTotal tests: 1. Passed: 1. Failed: 0. Skipped: 0.\n")
      end
    end

    context "when the tests finish" do
      it "shows the test summary" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        runner.input_received("Build completed")
        runner.input_received("Starting test execution, please wait...")
        runner.input_received("Passed   SampleProjectTests.UnitTest1.Test1")
        output.truncate(0)
        output.rewind

        runner.input_received("Total tests: 1. Passed: 1. Failed: 0. Skipped: 0.")

        expect(output.string).to eq("\nTotal tests: 1. Passed: 1. Failed: 0. Skipped: 0.\n")
      end
    end

    context "when the build fails" do
      it "outputs build failure with no details" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        output.truncate(0)
        output.rewind

        runner.input_received("Build FAILED.")
        runner.done_with_input

        expect(output.string).to eq("Build failed\n")
      end

      it "outputs build failure with details" do
        output = StringIO.new
        runner = build_runner(output)
        runner.input_received("Build started 4/17/19 8:22:32 PM.")
        output.truncate(0)
        output.rewind

        runner.input_received("Build FAILED.")
        runner.input_received("details1")
        runner.input_received("details2")
        runner.done_with_input

        expect(output.string).to include("details1")
        expect(output.string).to include("details2")
      end
    end
  end

  describe "Ending input in an unknown state" do
    it "outputs the only received line" do
      output = StringIO.new
      runner = build_runner(output)
      runner.input_received("RANDOM INPUT")

      runner.done_with_input

      expect(output.string).to eq("RANDOM INPUT\n")
    end
  end

end
