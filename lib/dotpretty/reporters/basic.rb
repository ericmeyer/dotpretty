module Dotpretty
  module Reporters
    class Basic

      def initialize(output)
        self.output = output
      end

      def build_started
        output.puts("Build started")
      end

      def build_completed
        output.puts("Build completed")
        output.puts("")
      end

      def starting_tests
        output.puts("Starting test execution...")
      end

      def test_passed(test_name)
        output.puts("Passed   #{test_name}")
      end

      def test_failed(failing_test)
        output.puts("Failed   #{failing_test[:name]}")
        failing_test[:details].each do |line|
          output.puts(line)
        end
      end

      def show_test_summary(summary)
        output.puts("\nTotal tests: #{summary[:totalTests]}. Passed: #{summary[:passedTests]}. Failed: #{summary[:failedTests]}. Skipped: #{summary[:skippedTests]}.\n")
      end

      private

      attr_accessor :output

    end
  end
end
