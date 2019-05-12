module Dotpretty
  module Reporters
    class Progress

      def initialize(colorer:, output:)
        self.extend(colorer)
        self.failing_tests = []
        self.output = output
      end

      def build_completed
        output.puts("Build completed")
        output.puts("")
      end

      def build_started
        output.puts("Build started")
      end

      def build_failed(failure_details)
      end

      def show_test_summary(summary)
        output.puts("")
        output.puts("")
        show_failure_summary if !failing_tests.empty?
        output.puts("Total tests: #{summary[:totalTests]}. Passed: #{summary[:passedTests]}. Failed: #{summary[:failedTests]}. Skipped: #{summary[:skippedTests]}.\n")
      end

      def starting_tests
        output.puts("Starting test execution")
      end

      def test_failed(failing_test)
        failing_tests << failing_test
        output.print(red("F"))
      end

      def test_passed(passing_test)
        output.print(green("."))
      end

      private

      def show_failure_summary
        output.puts("Failures:")
        output.puts("")
        failing_tests.each_with_index do |failing_test, index|
          output.puts(red("  #{index + 1}) #{failing_test[:name]}"))
          output.puts("")
          failing_test[:details].each do |detail|
            output.puts("      #{detail}")
          end
          output.puts("")
        end
        output.puts("")
      end

      attr_accessor :failing_tests, :output

    end
  end
end
