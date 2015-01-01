require 'nightwatch/filter'

module Nightwatch
  self.configure do
    config.logger.use Nightwatch::Mongo
    config.middleware.use Nightwatch::DuplicateFilter
  end
end
