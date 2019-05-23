require "dotpretty/reporters/browser"
require "fakes/http_client"

describe Dotpretty::Reporters::Browser do

  it "implements the interface defined by Fakes::Reporter" do
    expect(Dotpretty::Reporters::Browser).to be_substitutable_for(Fakes::Reporter)
  end

  def build_reporter(http_client)
    return Dotpretty::Reporters::Browser.new({ http_client: http_client })
  end

  describe "When the build has started" do
    it "posts an to a specific URL" do
      http_client = Fakes::HttpClient.new
      reporter = build_reporter(http_client)

      reporter.build_started

      expect(http_client).to have_been_told_to(:post_json).with("/build_started")
    end
  end

  describe "Showing the test summary" do
    context "when there are no tests" do
      it "posts an empty summary" do
        http_client = Fakes::HttpClient.new
        reporter = build_reporter(http_client)
        reporter.starting_tests

        reporter.show_test_summary({})

        expect(http_client).to have_been_told_to(:post_json).with("/update_results", { tests: [] })
      end
    end

    context "when there is one test" do
      it "posts a passing test" do
        http_client = Fakes::HttpClient.new
        reporter = build_reporter(http_client)
        reporter.starting_tests
        reporter.test_passed(name: "MyTest")

        reporter.show_test_summary({})

        expect(http_client).to have_been_told_to(:post_json).with("/update_results", {
          tests: [{
            name: "MyTest",
            result: "passed"
          }]
        })
      end

      it "posts a failing test" do
        http_client = Fakes::HttpClient.new
        reporter = build_reporter(http_client)
        reporter.starting_tests
        reporter.test_failed(name: "MyTest", details: ["1", "2", "3"])

        reporter.show_test_summary({})

        expect(http_client).to have_been_told_to(:post_json).with("/update_results", {
          tests: [{
            details: ["1", "2", "3"],
            name: "MyTest",
            result: "failed"
          }]
        })
      end

      it "posts a skipped test" do
        http_client = Fakes::HttpClient.new
        reporter = build_reporter(http_client)
        reporter.starting_tests
        reporter.test_skipped(name: "MyTest")

        reporter.show_test_summary({})

        expect(http_client).to have_been_told_to(:post_json).with("/update_results", {
          tests: [{
            name: "MyTest",
            result: "skipped"
          }]
        })
      end
    end
  end

end
