module Nightwatch
  def self.autoload(sym, path)
    Kernel.autoload(sym, File.expand_path('../' + path, __FILE__))
  end

  self.autoload(:MongoLogger, 'logger/mongo.rb')
  self.autoload(:DuplicateFilter, 'middleware/duplicate_filter.rb')
  self.autoload(:RbConfig, 'middleware/rb_config.rb')
  self.autoload(:Rake, 'middleware/rake.rb')
  self.autoload(:Thread, 'middleware/thread.rb')
  self.autoload(:Env, 'middleware/env.rb')
end
