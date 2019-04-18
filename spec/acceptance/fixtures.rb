module Fixtures

  def self.each_line(name, &block)
    read(name).each_line(&block)
  end

  def self.read(name)
    fixtures_root = File.expand_path(File.join(File.dirname(__FILE__), "fixtures"))
    return File.read(File.join(fixtures_root, name))
  end

end
