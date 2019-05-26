require "dotpretty/reporters/factory"
require "dotpretty/reporters/names"
require "stringio"

describe Dotpretty::Reporters::Factory do

  it "builds a basic reporter" do
    reporter = Dotpretty::Reporters::Factory.build_reporter(Dotpretty::Reporters::Names::BASIC, {
      color: false,
      output: StringIO.new
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Basic)
  end

  it "builds a JSON reporter" do
    reporter = Dotpretty::Reporters::Factory.build_reporter(Dotpretty::Reporters::Names::JSON, {
      output: StringIO.new
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Json)
  end

  it "builds a progress reporter" do
    reporter = Dotpretty::Reporters::Factory.build_reporter(Dotpretty::Reporters::Names::PROGRESS, {
      color: false,
      output: StringIO.new
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Progress)
  end

  it "defaults to a basic reporter" do
    reporter = Dotpretty::Reporters::Factory.build_reporter(nil, {
      color: false,
      output: StringIO.new
    })
    expect(reporter).to be_kind_of(Dotpretty::Reporters::Basic)
  end

end
