module Dotpretty
  class StateDetails

    def initialize(options)
      self.exit_action = options[:exit_action]
      self.transitions = options[:transitions]
    end

    def trigger(event, &block)
      block.call(transitions[event], exit_action) if transitions[event]
    end

    private

    attr_accessor :exit_action, :transitions

  end
end
