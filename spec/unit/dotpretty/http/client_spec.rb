require "dotpretty/http/client"
require "fakes/http_client"

describe Dotpretty::Http::Client do

  it "implements the interface defined by Fakes::HttpClient" do
    expect(Dotpretty::Http::Client).to be_substitutable_for(Fakes::HttpClient)
  end

  describe "Posting JSON" do
    it "posts to the full URI" do
      client = Dotpretty::Http::Client.new({ api_root: "http://foo.com/api"})
      allow(HTTParty).to receive(:post)

      client.post_json("/bar", {})

      expect(HTTParty).to have_received(:post).with("http://foo.com/api/bar", kind_of(Hash))
    end

    it "posts the body" do
      client = Dotpretty::Http::Client.new({ api_root: "http://foo.com/api"})
      allow(HTTParty).to receive(:post)
      data = { some: "data" }

      client.post_json("/bar", data)

      expect(HTTParty).to have_received(:post).with(kind_of(String), hash_including({
        body: data.to_json
      }))
    end

    it "sets the content type" do
      client = Dotpretty::Http::Client.new({ api_root: "http://foo.com/api"})
      allow(HTTParty).to receive(:post)
      data = { some: "data" }

      client.post_json("/bar", data)

      expect(HTTParty).to have_received(:post).with(kind_of(String), hash_including({
        headers: {
          "Content-Type": "application/json"
        }
      }))
    end
  end

end
