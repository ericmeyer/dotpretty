module Fakes
  class Reporter

    Surrogate.endow(self)

    define(:build_completed)
    define(:build_failed) { |failure_details| }
    define(:build_started)
    define(:show_test_summary) { |test_summary| }
    define(:starting_tests)
    define(:starting_tests)
    define(:test_failed) { |failing_test| }
    define(:test_passed) { |passing_test_name| }
    define(:test_skipped) { |skipped_test_name| }

  end
end
