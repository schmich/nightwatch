require 'nightwatch/filter'

module Nightwatch
  self.configure do
    config.logger.use Nightwatch::MongoLogger
    config.middleware.use Nightwatch::DuplicateFilter
    config.middleware.use Nightwatch::RbConfig
  end
end
