module Dotpretty
  class State

    def self.build(name, &definition)
      state = State.new(name)
      state.instance_eval(&definition)
      return state
    end

    attr_reader :name

    def initialize(name)
      self.name = name
      self.transitions = {}
    end

    def transition(event, next_state)
      transitions[event] = next_state
    end

    def trigger(event, &block)
      block.call(transitions[event]) if transitions[event]
    end

    private

    attr_accessor :transitions
    attr_writer :name

  end
end
