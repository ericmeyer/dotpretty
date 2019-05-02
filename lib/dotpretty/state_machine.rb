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
      current_state.trigger(event) do |transition, exit_action|
        perform(exit_action, *args) if current_state_name != transition[:next_state_name]
        perform(transition[:action], *args)
        if current_state_name != transition[:next_state_name]
          self.current_state_name = transition[:next_state_name]
          perform(current_state.entry_action, *args)
        end
      end
    end

    private

    def perform(action, *args)
      observer.send(action, *args) if action
    end

    def current_state
      states[current_state_name] || StateDetails.new({
        entry_action: nil,
        exit_action: nil,
        transitions: {}
      })
    end

    attr_accessor :observer, :states
    attr_writer :current_state_name

  end
end
