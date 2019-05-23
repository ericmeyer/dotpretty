require "dotpretty/reporters/progress"
require "dotpretty/color_palettes/null"
require "fakes/color_palette"
require "fakes/reporter"
require "stringio"

describe Dotpretty::Reporters::Progress do

  it "implements the interface defined by Fakes::Reporter" do
    expect(Dotpretty::Reporters::Progress).to be_substitutable_for(Fakes::Reporter)
  end

  def build_reporter(output, color_palette = Dotpretty::ColorPalettes::Null)
    return Dotpretty::Reporters::Progress.new({
      color_palette: color_palette,
      output: output
    })
  end

  describe "Showing test output" do
    it "prints a dot for a passing test" do
      output = StringIO.new
      reporter = build_reporter(output)

      reporter.test_passed(nil)

      expect(output.string).to eq(".")
    end

    it "prints a F for a failing test" do
      output = StringIO.new
      reporter = build_reporter(output)

      reporter.test_failed({})

      expect(output.string).to eq("F")
    end
  end

  describe "Showing the test summary" do
    it "shows a summary when there are no failing tests" do
      output = StringIO.new
      reporter = build_reporter(output)

      reporter.show_test_summary({
        failedTests: 1,
        passedTests: 2,
        skippedTests: 3,
        totalTests: 4
      })

      expect(output.string.strip).to eq("Total tests: 4. Passed: 2. Failed: 1. Skipped: 3.")
    end

    it "shows a failing test with no details" do
      output = StringIO.new
      reporter = build_reporter(output)
      reporter.test_failed({
        name: "MyFailingTest",
        details: []
      })

      reporter.show_test_summary({})

      expect(output.string.strip).to include("MyFailingTest")
    end

    it "shows a failing test with details" do
      output = StringIO.new
      reporter = build_reporter(output)
      reporter.test_failed({
        name: "MyFailingTest",
        details: [
          "Detail One",
          "Detail Two"
        ]
      })

      reporter.show_test_summary({})

      expect(output.string.strip).to include("MyFailingTest")
      expect(output.string.strip).to include("Detail One")
      expect(output.string.strip).to include("Detail Two")
    end

    context "with color" do
      it "shows the summary as red when there are failing tests" do
        output = StringIO.new
        reporter = build_reporter(output, Fakes::ColorPalette)

        reporter.show_test_summary({
          failedTests: 1,
          passedTests: 2,
          skippedTests: 3,
          totalTests: 4
        })

        expect(output.string.strip).to eq("{red}Total tests: 4. Passed: 2. Failed: 1. Skipped: 3.{reset}")
      end

      it "shows the summary as green when all tests pass" do
        output = StringIO.new
        reporter = build_reporter(output, Fakes::ColorPalette)

        reporter.show_test_summary({
          failedTests: 0,
          passedTests: 7,
          skippedTests: 0,
          totalTests: 7
        })

        expect(output.string.strip).to eq("{green}Total tests: 7. Passed: 7. Failed: 0. Skipped: 0.{reset}")
      end
    end
  end

end
