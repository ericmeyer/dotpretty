require "dotpretty/state_details"

module Dotpretty
  class StateMachine

    def initialize(options)
      self.current_state_name = options.fetch(:initial_state)
      self.observer = options.fetch(:observer)
      self.states = options.fetch(:states)
    end

    attr_reader :current_state_name

    def trigger(event)
      current_state_transitions.trigger(event) do |transition|
        observer.send(transition[:action]) if transition[:action]
        self.current_state_name = transition[:next_state]
      end
    end

    private

    def current_state_transitions
      states[current_state_name] || StateDetails.new(current_state_name)
    end

    attr_accessor :observer, :states
    attr_writer :current_state_name

  end
end
