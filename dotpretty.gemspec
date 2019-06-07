require_relative "./lib/dotpretty/version"

Gem::Specification.new do |s|
  s.add_runtime_dependency "httparty", "~> 0.17"
  s.authors = [ "Eric Meyer" ]
  s.date = "2019-05-02"
  s.description = "A gem to parse and improve the output of the dotnet command"
  s.executables = [ "dotpretty" ]
  s.files = Dir.glob("{lib}/**/*.rb")
  s.homepage = "https://github.com/ericmeyer/dotpretty"
  s.license = "MIT"
  s.name = "dotpretty"
  s.summary = "A gem to improve dotnet output"
  s.version = Dotpretty::VERSION
end
