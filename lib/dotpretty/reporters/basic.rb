require "dotpretty/reporters/test_summary_formatter"

module Dotpretty
  module Reporters
    class Basic

      def initialize(color_palette:, output:)
        self.color_palette = color_palette
        self.extend(color_palette)
        self.output = output
      end

      def build_started
        output.puts("Build started")
      end

      def build_failed_to_start(raw_input_inlines)
        raw_input_inlines.each do |raw_input_line|
          output.puts(raw_input_line)
        end
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

      def test_passed(name:)
        output.puts("#{green("Passed")}   #{name}")
      end

      def test_skipped(name:)
        output.puts("#{yellow("Skipped")}  #{name}")
      end

      def test_failed(name:, details:)
        output.puts("#{red("Failed")}   #{name}")
        details.each do |line|
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
        return Dotpretty::Reporters::TestSummaryFormatter.new({
          color_palette: color_palette,
          summary: summary
        }).colored_message
      end

      attr_accessor :color_palette, :output

    end
  end
end
