require "rspec"
require "dotpretty/state_machine_builder"

describe Dotpretty::StateMachineBuilder do

  def build(observer=nil, &definition)
    return Dotpretty::StateMachineBuilder.build(observer, &definition)
  end

  describe "Building the state machine" do
    it "has the initial state as the only state" do
      basic_machine = build do
        state :a do
        end
      end

      expect(basic_machine.current_state_name).to eq(:a)
    end

    it "has the first state as the initial state" do
      basic_machine = build do
        state :a do
        end
        state :b do
        end
      end

      expect(basic_machine.current_state_name).to eq(:a)
    end
  end

  describe "Triggering events" do
    it "transitions to another state" do
      basic_machine = build do
        state :a do
          transition :go_to_b, :b
        end
      end

      basic_machine.trigger(:go_to_b)

      expect(basic_machine.current_state_name).to eq(:b)
    end

    it "does not change state when there is an unknown event" do
      basic_machine = build do
        state :a do
          transition :go_to_b, :b
        end
      end

      basic_machine.trigger(:unknown_event)

      expect(basic_machine.current_state_name).to eq(:a)
    end

    it "does nothing when the state has no explicit definition" do
      basic_machine = build do
        state :a do
          transition :go_to_b, :b
        end
      end
      basic_machine.trigger(:go_to_b)

      basic_machine.trigger(:unknown_event)

      expect(basic_machine.current_state_name).to eq(:b)
    end
  end

  describe "Transition actions" do
    it "is triggered when transitioning" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          transition :go_to_b, :b, :some_action
        end
      end

      expect(observer).to receive(:some_action)

      basic_machine.trigger(:go_to_b)
    end

    it "accepts additional data" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          transition :go_to_b, :b, :some_action
        end
      end

      expect(observer).to receive(:some_action).with("Some data")

      basic_machine.trigger(:go_to_b, "Some data")
    end
  end
end
