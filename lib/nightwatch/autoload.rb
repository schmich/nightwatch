module Nightwatch
  def self.autoload(sym, path)
    Kernel.autoload(sym, File.expand_path('../' + path, __FILE__))
  end

  self.autoload(:MongoLogger, 'logger/mongo.rb')
  self.autoload(:RbConfig, 'ext/rb_config.rb')
  self.autoload(:Rake, 'ext/rake.rb')
  self.autoload(:Env, 'ext/env.rb')
end
