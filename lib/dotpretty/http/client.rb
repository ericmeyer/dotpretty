require "httparty"

module Dotpretty
  module Http
    class Client

      def initialize(api_root:)
        self.api_root = api_root
      end

      def post_json(route, data=nil)
        HTTParty.post("#{api_root}#{route}", {
          body: data.to_json,
          headers: {
            "Content-Type": "application/json"
          }
        })
      end

      private

      attr_accessor :api_root

    end
  end
end
