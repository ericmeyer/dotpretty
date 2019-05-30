require "dotpretty/reporters/factory"
require "dotpretty/reporters/names"
require "fakes/color_palette"
require "stringio"

describe Dotpretty::Reporters::Factory do

  def factory
    return Dotpretty::Reporters::Factory.new({
      color_palette: Fakes::ColorPalette,
      output: StringIO.new
    })
  end

  it "builds a basic reporter" do
    reporter = factory.build_reporter({
      name: Dotpretty::Reporters::Names::BASIC
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Basic)
  end

  it "builds a JSON reporter" do
    reporter = factory.build_reporter({
      name: Dotpretty::Reporters::Names::JSON
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Json)
  end

  it "builds a progress reporter" do
    reporter = factory.build_reporter({
      name: Dotpretty::Reporters::Names::PROGRESS
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Progress)
  end

end
