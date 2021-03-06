require "dotpretty/parser"
require "dotpretty/reporters/basic"
require "dotpretty/state_machine/state_machine_builder"

module Dotpretty
  class Runner

    def initialize(reporter:)
      self.parser = Dotpretty::Parser.new({ reporter: reporter })
      self.state_machine = Dotpretty::StateMachine::StateMachineBuilder.build(parser) do
        state :waiting_for_build_to_start do
          transition :build_failed_to_start, :done, :build_failed_to_start
          transition :received_input_line, :determining_if_build_started
        end
        state :determining_if_build_started do
          on_entry :parse_prebuild_input
          transition :build_started, :build_in_progress, :build_started
          transition :build_did_not_start, :waiting_for_build_to_start
        end
        state :build_in_progress do
          transition :received_build_input, :parsing_build_input
        end
        state :parsing_build_input do
          on_entry :parse_build_input
          transition :build_completed, :ready_to_run_tests, :build_completed
          transition :build_failed, :reading_build_failure_details, :reset_build_failure_details
          transition :received_build_input, :build_in_progress
        end
        state :reading_build_failure_details do
          transition :received_build_failure_details, :reading_build_failure_details, :track_build_failure_details
          transition :end_of_input, :done, :report_failing_build
        end
        state :ready_to_run_tests do
          transition :received_input_line, :determining_if_tests_started
        end
        state :determining_if_tests_started do
          on_entry :determine_if_tests_started
          transition :tests_started, :waiting_for_test_input, :starting_tests
          transition :tests_did_not_start, :ready_to_run_tests
        end
        state :waiting_for_test_input do
          transition :test_input_received, :parsing_test_input
        end
        state :parsing_test_input do
          on_entry :parse_test_input
          transition :received_other_input, :waiting_for_test_input
          transition :test_failed, :waiting_for_failure_details, :reset_current_failing_test
          transition :test_passed, :waiting_for_test_input, :test_passed
          transition :test_skipped, :waiting_for_test_input, :test_skipped
          transition :tests_completed, :done, :show_test_summary
        end
        state :waiting_for_failure_details do
          transition :received_failure_details, :reading_failure_details
        end
        state :reading_failure_details do
          on_entry :parse_failure_line
          transition :done_reading_failure, :parsing_test_input, :report_failing_test
          transition :received_failure_output, :waiting_for_failure_details, :track_failure_details
        end
        state :parsing_failure_line do
          on_entry :parse_failure_line
          transition :received_failure_output, :reading_failure_details, :track_failure_details
          transition :tests_completed, :done, :show_test_summary
        end
      end
      parser.state_machine = state_machine
    end

    def input_received(input_line)
      parser.parse_line(input_line)
    end

    def done_with_input
      parser.handle_end_of_input
    end

    private

    attr_accessor :parser, :output, :state_machine

  end
end
