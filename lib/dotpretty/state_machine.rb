require "dotpretty/state"

module Dotpretty
  class StateMachineBuilder
    def self.build(&definition)
      state_machine = Dotpretty::StateMachine.new
      state_machine.instance_eval(&definition)
      return state_machine
    end
  end
  class StateMachine

    def self.build(&definition)
      return StateMachineBuilder.build(&definition)
    end

    def initialize
      self.states = {}
    end

    attr_reader :current_state_name

    def state(name, &definition)
      state = State.build(name, &definition)
      states[name] = state
      self.current_state_name = name if !current_state_name
    end

    def trigger(event)
      current_state.trigger(event) do |next_state_name|
        self.current_state_name = next_state_name
      end
    end

    private

    def current_state
      states[current_state_name]
    end

    attr_accessor :states
    attr_writer :current_state_name

  end
end
