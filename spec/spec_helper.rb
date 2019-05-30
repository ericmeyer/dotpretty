require "surrogate"
require "surrogate/rspec"

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end

require "dotpretty/reporters/factory"
require "fakes/color_palette"
require "stringio"
def reporter_factory(output: StringIO.new)
  return Dotpretty::Reporters::Factory.new({
    color_palette: Fakes::ColorPalette,
    output: output
  })
end
