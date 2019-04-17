module Dotpretty
  class StateDetails

    def initialize(options)
      self.transitions = options[:transitions]
    end

    def trigger(event, &block)
      block.call(transitions[event]) if transitions[event]
    end

    private

    attr_accessor :transitions

  end
end
