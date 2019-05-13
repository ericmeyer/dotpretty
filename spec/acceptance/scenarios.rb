module Dotpretty
  module AcceptanceTestScenarios

    ALL = [{
      color: false,
      description: "one passing test",
      filename: "single_passing_test"
    }, {
      color: false,
      description: "one passing and one failing test",
      filename: "one_passing_one_failing"
    }, {
      color: true,
      description: "one passing and one failing test with color",
      filename: "one_passing_one_failing"
    }, {
      color: false,
      description: "the last test failing",
      filename: "last_test_failing"
    }, {
      color: false,
      description: "a failing build",
      filename: "failing_build"
    }]

  end
end
