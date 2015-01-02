require 'rbconfig'
require 'deep_merge'

module Nightwatch
  class RbConfig
    def exception(exception, record)
      record.deep_merge!({
        runtime: {
          config: ::RbConfig::CONFIG
        }
      })
      return exception, record
    end
  end
end
