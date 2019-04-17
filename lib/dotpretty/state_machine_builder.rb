require "dotpretty/state_details"

module Dotpretty
  class StateMachineBuilder

    class StateDetailsBuilder

      def self.build(name, &definition)
        builder = StateDetailsBuilder.new(name)
        builder.instance_eval(&definition)
        return builder.build
      end

      def initialize(name)
        self.name = name
        self.transitions = {}
      end

      def build
        StateDetails.new({
          name: name,
          transitions: transitions
        })
      end

      def transition(event, next_state)
        transitions[event] = next_state
      end

      private

      attr_accessor :name, :transitions

    end

    def self.build(&definition)
      builder = Dotpretty::StateMachineBuilder.new
      builder.instance_eval(&definition)
      return builder.build
    end

    def initialize
      self.states = {}
    end

    def state(name, &definition)
      state = StateDetailsBuilder.build(name, &definition)
      states[name] = state
      self.initial_state = name if !initial_state
    end

    def build
      Dotpretty::StateMachine.new({
        initial_state: initial_state,
        states: states
      })
    end

    private

    attr_accessor :initial_state, :states

  end
end
