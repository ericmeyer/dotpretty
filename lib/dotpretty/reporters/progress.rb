module Dotpretty
  module Reporters
    class Progress

      def initialize(colorer:, output:)
        self.extend(colorer)
        self.failing_tests = []
        self.skipped_test_names = []
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
        output.puts("Build failed")
        failure_details.each do |detail|
          output.puts(detail)
        end
      end

      def show_test_summary(summary)
        output.puts("")
        output.puts("")
        show_skipped_summary if !skipped_test_names.empty?
        show_failure_summary if !failing_tests.empty?
        output.puts(formatted_test_summary(summary))
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

      def test_skipped(test_name)
        skipped_test_names << test_name
        output.print("*")
      end

      private

      def formatted_test_summary(summary)
        message = "Total tests: #{summary[:totalTests]}. Passed: #{summary[:passedTests]}. Failed: #{summary[:failedTests]}. Skipped: #{summary[:skippedTests]}."
        if summary[:totalTests] == summary[:passedTests]
          return green(message)
        else
          return red(message)
        end
      end

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

      def show_skipped_summary
        output.puts("Skipped:")
        output.puts("")
        skipped_test_names.each_with_index do |test_name, index|
          output.puts("  #{index + 1}) #{test_name}")
        end
        output.puts("")
      end

      attr_accessor :failing_tests, :output, :skipped_test_names

    end
  end
end
