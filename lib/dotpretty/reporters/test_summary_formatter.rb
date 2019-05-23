module Dotpretty
  module Reporters
    class TestSummaryFormatter

      def initialize(color_palette:, summary:)
        self.extend(color_palette)
        self.summary = summary
      end

      def colored_message
        message = "Total tests: #{summary[:totalTests]}. Passed: #{summary[:passedTests]}. Failed: #{summary[:failedTests]}. Skipped: #{summary[:skippedTests]}."
        if summary[:passedTests] == summary[:totalTests]
          return green(message)
        elsif summary[:failedTests] > 0
          return red(message)
        else
          return yellow(message)
        end
      end

      private

      attr_accessor :summary

    end
  end
end
