module Dotpretty
  class Container
    class << self

      def register(name, &block)
        @dependencies ||= {}
        @dependencies[name] = block
      end

      def resolve(name)
        @dependencies.fetch(name).call
      end

    end

  end
end
