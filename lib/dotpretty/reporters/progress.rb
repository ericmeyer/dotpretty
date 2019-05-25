module Dotpretty
  module Reporters
    class Progress

      def initialize(color_palette:, output:)
        self.color_palette = color_palette
        self.extend(color_palette)
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

      def test_failed(name:, details:)
        failing_tests << {
          details: details,
          name: name
        }
        output.print(red("F"))
      end

      def test_passed(name:)
        output.print(green("."))
      end

      def test_skipped(name:)
        skipped_test_names << name
        output.print(yellow("*"))
      end

      private

      def formatted_test_summary(summary)
        return Dotpretty::Reporters::TestSummaryFormatter.new({
          color_palette: color_palette,
          summary: summary
        }).colored_message
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
          output.puts(yellow("  #{index + 1}) #{test_name}"))
        end
        output.puts("")
      end

      attr_accessor :color_palette, :failing_tests, :output, :skipped_test_names

    end
  end
end
