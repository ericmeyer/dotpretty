require "dotpretty/aggregator"

describe Dotpretty::Aggregator do

  describe "Showing the test summary" do
    it "gives the reported the information in a structured format" do
      reporter = double("Reporter", show_test_summary: nil)
      aggregator = Dotpretty::Aggregator.new({reporter: reporter})

      expect(reporter).to receive(:show_test_summary).with({
        failedTests: 789,
        passedTests: 456,
        skippedTests: 987,
        totalTests: 123
      })

      aggregator.show_test_summary("Total tests: 123. Passed: 456. Failed: 789. Skipped: 987.")
    end
  end

end
