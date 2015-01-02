module Nightwatch
  def self.autoload(sym, path)
    Kernel.autoload(sym, File.expand_path('../' + path, __FILE__))
  end

  self.autoload(:MongoLogger, 'logger/mongo.rb')
  self.autoload(:FileLogger, 'logger/file.rb')
  self.autoload(:DuplicateFilter, 'middleware/duplicate_filter.rb')
  self.autoload(:Exclude, 'middleware/exclude.rb')
  self.autoload(:RbConfig, 'middleware/rb_config.rb')
  self.autoload(:Rake, 'middleware/rake.rb')
  self.autoload(:MainThread, 'middleware/main_thread.rb')
  self.autoload(:Thread, 'middleware/thread.rb')
  self.autoload(:Env, 'middleware/env.rb')
end
