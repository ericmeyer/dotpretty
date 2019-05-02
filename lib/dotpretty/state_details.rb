module Dotpretty
  class StateDetails

    def initialize(transitions:, exit_action:, entry_action:)
      self.entry_action = entry_action
      self.exit_action = exit_action
      self.transitions = transitions
    end

    attr_reader :entry_action

    def trigger(event, &block)
      transition = transitions[event]
      block.call(transition, exit_action) if transition
    end

    private

    attr_accessor :exit_action, :transitions
    attr_writer :entry_action

  end
end
