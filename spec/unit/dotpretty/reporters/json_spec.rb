require "dotpretty/reporters/json"
require "json"
require "stringio"
require "fakes/reporter"

describe Dotpretty::Reporters::Json do

  it "implements the interface defined by Fakes::Reporter" do
    expect(Dotpretty::Reporters::Json).to be_substitutable_for(Fakes::Reporter)
  end

  def build_json_reporter(output)
    reporter = Dotpretty::Reporters::Json.new(output)
  end

  describe "Showing the test summary" do
    context "when there have been no tests reported" do
      it "outputs an empty summary" do
        output = StringIO.new
        reporter = build_json_reporter(output)

        reporter.show_test_summary({
          failedTests: 0,
          passedTests: 0,
          skippedTests: 0,
          totalTests: 0
        })

        parsed_output = JSON.parse(output.string)
        expect(parsed_output).to eq({
          "tests" => []
        })
      end
    end

    context "when has been one passing test" do
      it "outputs a summary with that test" do
        output = StringIO.new
        reporter = build_json_reporter(output)
        reporter.test_passed({ name: "MyTest" })

        reporter.show_test_summary({
          failedTests: 0,
          passedTests: 1,
          skippedTests: 0,
          totalTests: 0
        })

        parsed_output = JSON.parse(output.string)
        expect(parsed_output).to eq({
          "tests" => [{
            "name" => "MyTest",
            "result" => "passed"
          }]
        })
      end
    end

    context "when has been one failing test" do
      it "outputs a summary with that test" do
        output = StringIO.new
        reporter = build_json_reporter(output)
        reporter.test_failed({
          name: "FailingTest",
          details: ["1", "2"]
        })

        reporter.show_test_summary({
          failedTests: 1,
          passedTests: 0,
          skippedTests: 0,
          totalTests: 0
        })

        parsed_output = JSON.parse(output.string)
        expect(parsed_output).to eq({
          "tests" => [{
            "name" => "FailingTest",
            "result" => "failed",
            "details" => ["1", "2"]
          }]
        })
      end
    end
  end

end
