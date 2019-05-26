require "dotpretty/container"
require "fakes/color_palette"
require "surrogate"
require "surrogate/rspec"

Dotpretty::Container.register(:color_palette) do
  Fakes::ColorPalette
end

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end
