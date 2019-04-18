require "dotpretty/reporter"
require "dotpretty/state_machine_builder"

module Dotpretty
  class Parser

    def initialize(options)
      self.output = options[:output]
      self.state_machine = Dotpretty::StateMachineBuilder.build(Dotpretty::Reporter.new(options)) do
        state :waiting do
          transition :build_started, :build_in_progress, :build_started
        end
        state :build_in_progress do
          transition :build_completed, :ready_to_run_tests, :build_completed
        end
        state :ready_to_run_tests do
          transition :starting_tests, :running_tests, :starting_tests
        end
        state :running_tests do
          transition :test_failed, :reading_test_failure, :test_failed
          transition :test_passed, :running_tests, :test_passed
          transition :tests_completed, :done, :show_test_summary
        end
        state :reading_test_failure do
          transition :test_passed, :running_tests, :test_passed
          transition :received_failure_output, :reading_test_failure, :show_failure_details
          transition :tests_completed, :done, :show_test_summary
        end
      end
    end

    def parse_line(input_line)
      case state_machine.current_state_name
      when :waiting
        state_machine.trigger(:build_started)
      when :build_in_progress
        state_machine.trigger(:build_completed) if input_line.match(/^Build completed/)
      when :ready_to_run_tests
        if input_line.match(/^Starting test execution, please wait...$/)
          state_machine.trigger(:starting_tests)
        end
      when :running_tests
        if input_line.start_with?("Passed")
          match = input_line.match(/^Passed\s+(.+)$/)
          state_machine.trigger(:test_passed, match[1])
        elsif input_line.start_with?("Failed")
          match = input_line.match(/^Failed\s+(.+)$/)
          state_machine.trigger(:test_failed, match[1])
        elsif input_line.start_with?("Total tests")
          state_machine.trigger(:tests_completed, input_line)
        end
      when :reading_test_failure
        if input_line.start_with?("Passed")
          match = input_line.match(/^Passed\s+(.+)$/)
          state_machine.trigger(:test_passed, match[1])
        elsif input_line.start_with?("Total tests")
          state_machine.trigger(:tests_completed, input_line)
        else
          state_machine.trigger(:received_failure_output, input_line)
        end
      end
    end

    private

    attr_accessor :output, :state_machine

  end
end
