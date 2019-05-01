require "dotpretty/state_details"

module Dotpretty
  class StateMachine

    def initialize(options)
      self.current_state_name = options.fetch(:initial_state)
      self.observer = options.fetch(:observer)
      self.states = options.fetch(:states)
    end

    attr_reader :current_state_name

    def trigger(event, *args)
      current_state_transitions.trigger(event) do |transition, exit_action|
        observer.send(transition[:action], *args) if transition[:action]
        if exit_action && current_state_name != transition[:next_state]
          observer.send(exit_action, *args)
        end
        self.current_state_name = transition[:next_state]
      end
    end

    private

    def current_state_transitions
      states[current_state_name] || StateDetails.new({ transitions: {} })
    end

    attr_accessor :observer, :states
    attr_writer :current_state_name

  end
end
