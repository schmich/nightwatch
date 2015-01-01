require 'rbconfig'
require 'deep_merge'

module Nightwatch
  class RbConfig
    def exception(exception, record)
      record = record.deep_merge({ ruby: { config: ::RbConfig::CONFIG } })
      return exception, record
    end
  end
end
