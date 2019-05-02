require "dotpretty/state_details"

module Dotpretty
  class StateMachine

    def initialize(initial_state:, observer:, states:)
      self.current_state_name = initial_state
      self.observer = observer
      self.states = states
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
      states[current_state_name] || StateDetails.new({
        exit_action: nil,
        name: nil,
        transitions: {}
      })
    end

    attr_accessor :observer, :states
    attr_writer :current_state_name

  end
end
