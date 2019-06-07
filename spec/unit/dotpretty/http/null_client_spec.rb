require "dotpretty/http/null_client"
require "fakes/http_client"

describe Dotpretty::Http::NullClient do

  it "implements the interface defined by Fakes::HttpClient" do
    expect(Dotpretty::Http::NullClient).to be_substitutable_for(Fakes::HttpClient)
  end

end
