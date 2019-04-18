require "dotpretty/state_machine_builder"

module Dotpretty
  class Parser

    def initialize(options)
      self.output = options[:output]
    end

    def parse_line(input_line)
      output.puts(input_line)
    end

    private

    attr_accessor :output, :state_machine

  end
end
