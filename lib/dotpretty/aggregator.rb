module Dotpretty
  class Aggregator

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
      reporter.show_failure_details(details)
    end

    def show_test_summary(summary)
      reporter.show_test_summary(summary)
    end

    def starting_tests
      reporter.starting_tests
    end

    def test_failed(test_name)
      reporter.test_failed(test_name)
    end

    def test_passed(test_name)
      reporter.test_passed(test_name)
    end

    private

    attr_accessor :reporter

  end
end
