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

      def transition(event, next_state, action = nil)
        transitions[event] = {
          action: action,
          next_state: next_state
        }
      end

      private

      attr_accessor :name, :transitions

    end

    def self.build(observer, &definition)
      builder = Dotpretty::StateMachineBuilder.new(observer)
      builder.instance_eval(&definition)
      return builder.build
    end

    def initialize(observer)
      self.observer = observer
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
        observer: observer,
        states: states
      })
    end

    private

    attr_accessor :initial_state, :observer, :states

  end
end
