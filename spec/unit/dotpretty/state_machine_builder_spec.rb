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

  describe "Exit actions" do
    it "triggers when leaving a state" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          on_exit :some_action
          transition :go_to_b, :b
        end
      end

      expect(observer).to receive(:some_action).with("Some data")

      basic_machine.trigger(:go_to_b, "Some data")
    end

    it "does not trigger when the state is unchanged" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          on_exit :some_action
          transition :stay_in_a, :a
        end
      end

      expect(observer).not_to receive(:some_action)

      basic_machine.trigger(:stay_in_a)
    end

    it "does not trigger when there is no transition defined for the event" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          on_exit :some_action
        end
      end

      expect(observer).not_to receive(:some_action)

      basic_machine.trigger(:some_event)
    end
  end

  describe "Entry actions" do
    it "triggers when entering a state" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          transition :go_to_b, :b
        end
        state :b do
          on_entry :some_action
        end
      end

      expect(observer).to receive(:some_action).with("Some data")

      basic_machine.trigger(:go_to_b, "Some data")
    end

    it "does not trigger when the state is unchanged" do
      observer = double("State Observer", some_action: nil)
      basic_machine = build(observer) do
        state :a do
          on_entry :some_action
          transition :stay_in_a, :a
        end
      end

      expect(observer).not_to receive(:some_action)

      basic_machine.trigger(:stay_in_a)
    end

    class FakeObserver
      attr_accessor :state_machine

      def trigger_go_to_c
        state_machine.trigger(:go_to_c)
      end
    end

    it "performs the action after the state has been updated" do
      observer = FakeObserver.new
      basic_machine = build(observer) do
        state :a do
          transition :go_to_b, :b
        end
        state :b do
          on_entry :trigger_go_to_c
          transition :go_to_c, :c
        end
      end
      observer.state_machine = basic_machine

      basic_machine.trigger(:go_to_b)

      expect(basic_machine.current_state_name).to eq(:c)
    end
  end

  describe "Multiple actions for the same event" do
    it "executes them in the correct order" do
      observer = double("State Observer", entry_action: nil, exit_action: nil, transition_action: nil)
      basic_machine = build(observer) do
        state :a do
          on_exit :exit_action
          transition :go_to_b, :b, :transition_action
        end
        state :b do
          on_entry :entry_action
        end
      end

      expect(observer).to receive(:exit_action).ordered
      expect(observer).to receive(:transition_action).ordered
      expect(observer).to receive(:entry_action).ordered

      basic_machine.trigger(:go_to_b)
      expect(basic_machine.current_state_name).to eq(:b)
    end
  end

end
