require "dotpretty/colorers/null"
require "dotpretty/reporters/basic"
require "fakes/colorer"
require "fakes/reporter"

describe Dotpretty::Reporters::Basic do

  it "implements the interface defined by Fakes::Reporter" do
    expect(Dotpretty::Reporters::Basic).to be_substitutable_for(Fakes::Reporter)
  end

  def build_reporter(output, colorer = Dotpretty::Colorers::Null)
    return Dotpretty::Reporters::Basic.new({
      colorer: colorer,
      output: output
    })
  end

  describe "Displaying the test summary" do
    context "without color" do
      it "shows a summary" do
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
    end

    context "with color" do
      it "displays the summary in red when there are failures" do
        output = StringIO.new
        reporter = build_reporter(output, Fakes::Colorer)

        reporter.show_test_summary({
          failedTests: 1,
          passedTests: 2,
          skippedTests: 3,
          totalTests: 4
        })

        expect(output.string.strip).to eq("{red}Total tests: 4. Passed: 2. Failed: 1. Skipped: 3.{reset}")
      end

      it "displays the summary in green when there are only passing tests" do
        output = StringIO.new
        reporter = build_reporter(output, Fakes::Colorer)

        reporter.show_test_summary({
          failedTests: 0,
          passedTests: 5,
          skippedTests: 0,
          totalTests: 5
        })

        expect(output.string.strip).to eq("{green}Total tests: 5. Passed: 5. Failed: 0. Skipped: 0.{reset}")
      end
    end
  end
end
