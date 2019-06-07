require "acceptance/fixtures"
require "dotpretty/color_palettes/null"
require "dotpretty/options"
require "dotpretty/reporters/names"
require "dotpretty/runner"
require "fakes/http_client"
require "stringio"

describe "The browser reporter" do

  def parse_input(filename, http_client)
    options = Dotpretty::Options.new({
      color_palette: Dotpretty::ColorPalettes::Null,
      http_client: http_client,
      output: StringIO.new,
      reporter_name: Dotpretty::Reporters::Names::BROWSER
    })
    runner = Dotpretty::Runner.new({ reporter: options.reporter })
    Fixtures.each_line(filename) { |line| runner.input_received(line) }
    runner.done_with_input
  end

  it "sends a build started notification" do
    http_client = Fakes::HttpClient.new

    parse_input("dotnet_input/one_passing_one_failing.log", http_client)

    request = http_client.request({route: "/build_started"})
    expect(request).not_to be_nil
    expect(request.data).to be_nil
  end

  it "sends the test summary with one passing and one failing test" do
    http_client = Fakes::HttpClient.new

    parse_input("dotnet_input/one_passing_one_failing.log", http_client)

    request = http_client.request({route: "/update_results"})
    expect(request).not_to be_nil
    expect(request.data).to eq({
      tests: [{
        details: [
          "Error Message:",
          " Assert.Equal() Failure",
          "Expected: 1",
          "Actual:   2",
          "Stack Trace:",
          "   at SampleProjectTests.UnitTest1.Test2() in /path/to/workspace/SampleSolution/SampleProjectTests/UnitTest1.cs:line 15",
        ],
        name: "SampleProjectTests.UnitTest1.Test2",
        result: "failed"
      }, {
        name: "SampleProjectTests.UnitTest1.Test1",
        result: "passed"
      }]
    })
    expect(http_client).to have_been_told_to(:post_json).with("/update_results", {
      tests: [{
        details: [
          "Error Message:",
          " Assert.Equal() Failure",
          "Expected: 1",
          "Actual:   2",
          "Stack Trace:",
          "   at SampleProjectTests.UnitTest1.Test2() in /path/to/workspace/SampleSolution/SampleProjectTests/UnitTest1.cs:line 15",
        ],
        name: "SampleProjectTests.UnitTest1.Test2",
        result: "failed"
      }, {
        name: "SampleProjectTests.UnitTest1.Test1",
        result: "passed"
      }]
    })
  end

  it "sends the test summary with a skipped test" do
    http_client = Fakes::HttpClient.new

    parse_input("dotnet_input/single_skipped_test.log", http_client)

    expect(http_client).to have_been_told_to(:post_json).with("/update_results", {
      tests: [{
        name: "SampleProjectTests.UnitTest1.Test1",
        result: "skipped"
      }]
    })
  end

end
