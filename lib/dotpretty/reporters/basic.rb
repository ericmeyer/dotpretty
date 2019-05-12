module Dotpretty
  module Reporters
    class Basic

      def initialize(colorer:, output:)
        self.extend(colorer)
        self.output = output
      end

      def build_started
        output.puts("Build started")
      end

      def build_completed
        output.puts("Build completed")
        output.puts("")
      end

      def build_failed(failure_details)
        output.puts("Build failed")
        failure_details.each do |detail|
          output.puts(detail)
        end
      end

      def starting_tests
        output.puts("Starting test execution...")
      end

      def test_passed(test_name)
        output.puts("#{green("Passed")}   #{test_name}")
      end

      def test_failed(failing_test)
        output.puts("#{red("Failed")}   #{failing_test[:name]}")
        failing_test[:details].each do |line|
          output.puts(line)
        end
      end

      def show_test_summary(summary)
        message = colored_message(summary)
        output.puts("")
        output.puts("#{message}")
      end

      private

      def colored_message(summary)
        message = "Total tests: #{summary[:totalTests]}. Passed: #{summary[:passedTests]}. Failed: #{summary[:failedTests]}. Skipped: #{summary[:skippedTests]}."
        if summary[:passedTests] == summary[:totalTests]
          return green(message)
        else
          return red(message)
        end
      end

      attr_accessor :output

    end
  end
end
