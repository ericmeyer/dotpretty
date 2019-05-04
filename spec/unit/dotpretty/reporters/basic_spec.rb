require "dotpretty/reporters/basic"
require "fakes/reporter"

describe Dotpretty::Reporters::Basic do

  it "implements the interface defined by Fakes::Reporter" do
    expect(Dotpretty::Reporters::Basic).to be_substitutable_for(Fakes::Reporter)
  end

end
