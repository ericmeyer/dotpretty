require "dotpretty/colorers/bash"

describe "Bash colored output" do

  class MyReporter
    include Dotpretty::Colorers::Bash
  end

  def bash_colorer
    return Dotpretty::Colorers::Bash
  end

  def reporter_with_colorer
    return MyReporter.new
  end

  it "displays green text" do
    colored_output = "#{bash_colorer::START_GREEN}123#{bash_colorer::RESET}"
    expect(reporter_with_colorer.green("123")).to eq(colored_output)
  end

  it "displays red text" do
    colored_output = "#{bash_colorer::START_RED}456#{bash_colorer::RESET}"
    expect(reporter_with_colorer.red("456")).to eq(colored_output)
  end

end
