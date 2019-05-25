require "dotpretty/parser"

describe Dotpretty::Parser do

  describe "Showing the test summary" do
    it "gives the reported the information in a structured format" do
      reporter = double("Reporter", show_test_summary: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})

      expect(reporter).to receive(:show_test_summary).with({
        failedTests: 789,
        passedTests: 456,
        skippedTests: 987,
        totalTests: 123
      })

      parser.show_test_summary("Total tests: 123. Passed: 456. Failed: 789. Skipped: 987.")
    end
  end

  describe "Parsing failure details" do
    it "is done reading the failing test when it encounters another failure" do
      reporter = double("Reporter", show_test_summary: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})
      state_machine = double("State Machine", trigger: nil)
      parser.state_machine = state_machine

      expect(state_machine).to receive(:trigger).with(:done_reading_failure, "Failed   Test2")

      parser.parse_failure_line("Failed   Test2")
    end
  end

  describe "Showing failing output" do
    it "reports a failure with no details" do
      reporter = double("Reporter", test_failed: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})
      parser.reset_current_failing_test("MyTest")

      expect(reporter).to receive(:test_failed).with({
        details: [],
        name: "MyTest"
      })

      parser.report_failing_test
    end

    it "reports a failure with details" do
      reporter = double("Reporter", test_failed: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})
      parser.reset_current_failing_test("MyTest")
      parser.track_failure_details("Foobar\n")

      expect(reporter).to receive(:test_failed).with({
        details: ["Foobar"],
        name: "MyTest"
      })

      parser.report_failing_test
    end

    it "does not track empty details" do
      reporter = double("Reporter", test_failed: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})
      parser.reset_current_failing_test("MyTest")
      parser.track_failure_details("Foobar\n")
      parser.track_failure_details("\n")

      expect(reporter).to receive(:test_failed).with({
        details: ["Foobar"],
        name: "MyTest"
      })

      parser.report_failing_test
    end
  end

  describe "Reporting a build failure" do
    it "shows a build failure with no details" do
      reporter = double("Reporter", show_build_failure: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})
      parser.reset_build_failure_details

      expect(reporter).to receive(:build_failed).with([])

      parser.report_failing_build
    end

    it "shows a build failure with details" do
      reporter = double("Reporter", show_build_failure: nil)
      parser = Dotpretty::Parser.new({reporter: reporter})
      parser.reset_build_failure_details

      expect(reporter).to receive(:build_failed).with([
        "details1",
        "details2"
      ])

      parser.track_build_failure_details("details1")
      parser.track_build_failure_details("details2")
      parser.report_failing_build
    end
  end
end
