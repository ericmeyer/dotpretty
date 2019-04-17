require "dotpretty/state_details"
require "dotpretty/state_machine_builder"

module Dotpretty
  class StateMachine

    def self.build(&definition)
      return StateMachineBuilder.build(&definition)
    end

    def initialize(options)
      self.states = options.fetch(:states)
      self.current_state_name = options.fetch(:initial_state)
    end

    attr_reader :current_state_name

    def trigger(event)
      current_state_transitions.trigger(event) do |next_state_name|
        self.current_state_name = next_state_name
      end
    end

    private

    def current_state_transitions
      states[current_state_name] || StateDetails.new(current_state_name)
    end

    attr_accessor :states, :states_old
    attr_writer :current_state_name

  end
end
