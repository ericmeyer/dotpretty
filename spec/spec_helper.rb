require "surrogate"
require "surrogate/rspec"

RSpec.configure do |config|
  config.filter_run_when_matching :focus
end
