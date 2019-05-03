module Dotpretty
  class Aggregator

    attr_accessor :state_machine

    def initialize(reporter:)
      self.reporter = reporter
    end

    def build_completed
      reporter.build_completed
    end

    def build_started
      reporter.build_started
    end

    def show_failure_details(details)
      current_failing_test[:details] << details
    end

    def show_test_summary(summary)
      match = summary.match(/^Total tests: (\d+). Passed: (\d+). Failed: (\d+). Skipped: (\d+)./)
      reporter.show_test_summary({
        failedTests: match[3].to_i,
        passedTests: match[2].to_i,
        skippedTests: match[4].to_i,
        totalTests: match[1].to_i
      })
    end

    def parse_failure_line(input_line)
      if input_line.start_with?("Passed")
        reporter.test_failed(current_failing_test)
        match = input_line.match(/^Passed\s+(.+)$/)
        state_machine.trigger(:test_passed, match[1])
      elsif input_line.start_with?("Total tests")
        reporter.test_failed(current_failing_test)
        state_machine.trigger(:tests_completed, input_line)
      else
        state_machine.trigger(:received_failure_output, input_line)
      end
    end

    def starting_tests
      reporter.starting_tests
    end

    def test_failed(test_name)
      self.current_failing_test = {
        details: [],
        name: test_name
      }
    end

    def test_passed(test_name)
      reporter.test_passed(test_name)
    end

    private

    attr_accessor :current_failing_test, :reporter

  end
end
