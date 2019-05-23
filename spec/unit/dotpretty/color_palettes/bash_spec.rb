require "dotpretty/color_palettes/bash"

describe "Bash colored output" do

  class MyReporter
    include Dotpretty::ColorPalettes::Bash
  end

  def bash_color_palette
    return Dotpretty::ColorPalettes::Bash
  end

  def reporter_with_color_palette
    return MyReporter.new
  end

  it "displays green text" do
    colored_output = "#{bash_color_palette::START_GREEN}123#{bash_color_palette::RESET}"
    expect(reporter_with_color_palette.green("123")).to eq(colored_output)
  end

  it "displays red text" do
    colored_output = "#{bash_color_palette::START_RED}456#{bash_color_palette::RESET}"
    expect(reporter_with_color_palette.red("456")).to eq(colored_output)
  end

end
