module Dotpretty
  class StateDetails

    def initialize(transitions:, exit_action:, name:)
      self.exit_action = exit_action
      self.transitions = transitions
    end

    def trigger(event, &block)
      block.call(transitions[event], exit_action) if transitions[event]
    end

    private

    attr_accessor :exit_action, :transitions

  end
end
