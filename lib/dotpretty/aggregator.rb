module Dotpretty
  class Aggregator

    BUILD_COMPLETED = /^Build completed/
    TEST_FAILED = /^Failed/
    TEST_PASSED = /^Passed/
    TEST_SUMMARY = /^Total tests/
    TESTS_STARTED = /^Starting test execution, please wait...$/

    attr_accessor :state_machine

    def initialize(reporter:)
      self.reporter = reporter
    end

    def parse_line(input_line)
      case state_machine.current_state_name
      when :waiting
        state_machine.trigger(:build_started)
      when :build_in_progress
        state_machine.trigger(:received_build_input, input_line)
      when :ready_to_run_tests
        state_machine.trigger(:received_input_line, input_line)
      when :waiting_for_test_input
        state_machine.trigger(:test_input_received, input_line)
      when :waiting_for_failure_details
        state_machine.trigger(:received_failure_details, input_line)
      when :reading_failure_details
        state_machine.trigger(:received_input_line, input_line)
      end
    end

    def parse_build_input(input_line)
      if input_line.match(BUILD_COMPLETED)
        state_machine.trigger(:build_completed)
      else
        state_machine.trigger(:received_build_input)
      end
    end

    def determine_if_tests_started(input_line)
      if input_line.match(TESTS_STARTED)
        state_machine.trigger(:tests_started)
      else
        state_machine.trigger(:tests_did_not_start)
      end

    end

    def parse_test_input(input_line)
      if input_line.match(TEST_PASSED)
        match = input_line.match(/^Passed\s+(.+)$/)
        state_machine.trigger(:test_passed, match[1])
      elsif input_line.match(TEST_FAILED)
        match = input_line.match(/^Failed\s+(.+)$/)
        state_machine.trigger(:test_failed, match[1])
      elsif input_line.match(TEST_SUMMARY)
        state_machine.trigger(:tests_completed, input_line)
      else
        state_machine.trigger(:received_other_input)
      end
    end

    def build_completed
      reporter.build_completed
    end

    def build_started
      reporter.build_started
    end

    def track_failure_details(details)
      current_failing_test[:details] << details.rstrip if details.rstrip != ""
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

    def report_failing_test(*args)
      reporter.test_failed(current_failing_test)
    end

    def parse_failure_line(input_line)
      if input_line.match(TEST_PASSED)
        state_machine.trigger(:done_reading_failure, input_line)
      elsif input_line.match(TEST_SUMMARY)
        state_machine.trigger(:done_reading_failure, input_line)
      elsif input_line.match(TEST_FAILED)
        state_machine.trigger(:done_reading_failure, input_line)
      else
        state_machine.trigger(:received_failure_output, input_line)
      end
    end

    def starting_tests
      reporter.starting_tests
    end

    def reset_current_failing_test(test_name)
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
