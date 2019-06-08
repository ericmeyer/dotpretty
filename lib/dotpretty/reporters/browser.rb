module Dotpretty
  module Reporters
    class Browser

      def initialize(http_client:)
        self.http_client = http_client
      end

      def build_completed
      end

      def build_failed_to_start(raw_input_inlines)
      end

      def build_failed(failure_details)
      end

      def build_started
        http_client.post_json("/build_started")
      end

      def show_test_summary(test_summary)
        http_client.post_json("/update_results", {
          tests: tests
        })
      end

      def starting_tests
        self.tests = []
      end

      def test_failed(name:, details:)
        tests << {
          details: details,
          name: name,
          result: "failed"
        }
      end

      def test_passed(name:)
        tests << {
          name: name,
          result: "passed"
        }
      end

      def test_skipped(name:)
        tests << {
          name: name,
          result: "skipped"
        }
      end

      private

      attr_accessor :http_client, :tests

    end
  end
end
