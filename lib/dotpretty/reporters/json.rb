require "json"

module Dotpretty
  module Reporters
    class Json

      def initialize(output)
        self.output = output
        self.tests = []
      end

      def build_started
      end

      def build_completed
      end

      def build_failed(failure_details)
      end

      def starting_tests
      end

      def test_passed(test_name)
        tests << {
          name: test_name,
          result: "passed"
        }
      end

      def test_failed(failing_test)
        tests << failing_test.merge({
          result: "failed"
        })
      end

      def show_test_summary(summary)
        output.puts({
          tests: tests
        }.to_json)
      end

      private

      attr_accessor :output, :tests

    end
  end
end
