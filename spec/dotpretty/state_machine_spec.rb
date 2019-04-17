require "rspec"
require "dotpretty/state_machine"

describe Dotpretty::StateMachine do

  def build(&definition)
    return Dotpretty::StateMachine.build(&definition)
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
  end
end
