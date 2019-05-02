module Dotpretty
  class Reporter

    def initialize(output:)
      self.output = output
    end

    def build_completed
      output.puts("Build completed")
      output.puts("")
    end

    def build_started
      output.puts("Build started")
    end

    def show_failure_details(details)
      output.puts("#{details}")
    end

    def show_test_summary(summary)
      output.puts("\n#{summary}")
    end

    def starting_tests
      output.puts("Starting test execution...")
    end

    def test_failed(test_name)
      output.puts("Failed   #{test_name}")
    end

    def test_passed(test_name)
      output.puts("Passed   #{test_name}")
    end

    private

    attr_accessor :output

  end
end
