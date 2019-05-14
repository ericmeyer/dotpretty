require "dotpretty/reporters/test_summary_formatter"
require "fakes/colorer"

describe Dotpretty::Reporters::TestSummaryFormatter do

  def colored_message(summary)
    Dotpretty::Reporters::TestSummaryFormatter.new({
      colorer: Fakes::Colorer,
      summary: summary
    }).colored_message
  end

  describe "The color of the message" do
    it "is green when all tests pass" do
      message = colored_message({
        failedTests: 0,
        passedTests: 123,
        skippedTests: 0,
        totalTests: 123
      })

      expect(message).to match("{green}")
    end

    it "is red when there is a failing test" do
      message = colored_message({
        failedTests: 5,
        passedTests: 5,
        skippedTests: 0,
        totalTests: 10
      })

      expect(message).to match("{red}")
    end

    it "is yellow when there is a skipped test" do
      message = colored_message({
        failedTests: 0,
        passedTests: 5,
        skippedTests: 5,
        totalTests: 10
      })

      expect(message).to match("{yellow}")
    end

    it "is red when there is are both failed and skipped tests" do
      message = colored_message({
        failedTests: 2,
        passedTests: 3,
        skippedTests: 5,
        totalTests: 10
      })

      expect(message).to match("{red}")
    end
  end

end
