require "dotpretty/reporters/json"
require "json"
require "stringio"

describe Dotpretty::Reporters::Json do

  describe "Showing the test summary" do
    context "when there have been no tests reported" do
      it "outputs an empty summary" do
        output = StringIO.new
        reporter = Dotpretty::Reporters::Json.new({output: output})

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
        reporter = Dotpretty::Reporters::Json.new({output: output})
        reporter.test_passed("MyTest")

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
        reporter = Dotpretty::Reporters::Json.new({output: output})
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
