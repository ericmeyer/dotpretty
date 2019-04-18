require "dotpretty/parser"
require "stringio"

describe Dotpretty::Parser do

  describe "Parsing input" do
    it "starts with no output" do
      output = StringIO.new
      parser = Dotpretty::Parser.new({ output: output })

      expect(output.string).to eq("")
    end

    it "outputs that input" do
      output = StringIO.new
      parser = Dotpretty::Parser.new({ output: output })

      parser.parse_line("Build started 4/17/19 8:22:32 PM.")

      expect(output.string).to eq("Build started 4/17/19 8:22:32 PM.\n")
    end
  end

end
