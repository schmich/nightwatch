module Nightwatch
  def self.autoload(sym, path)
    Kernel.autoload(sym, File.expand_path('../' + path, __FILE__))
  end

  self.autoload(:MongoLogger, 'logger/mongo.rb')
end
