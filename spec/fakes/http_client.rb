module Fakes
  class HttpRequest

    attr_reader :data, :route

    def initialize(data:, route:)
      self.route = route
      self.data = data
    end

    private

    attr_writer :data, :route

  end
  class HttpClient

    Surrogate.endow(self)

    define(:post_json) do |route, data=nil|
      self.requests << HttpRequest.new({
        data: data,
        route: route
      })
    end

    attr_reader :requests

    def initialize
      self.requests = []
    end

    def request(route:)
      return requests.find { |r| r.route == route }
    end

    private

    attr_writer :requests

  end
end
