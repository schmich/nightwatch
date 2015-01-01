require 'rbconfig'
require 'deep_merge'

module Nightwatch
  class ConfigFilter
    def exception(exception, attrs)
      attrs = attrs.deep_merge({ ruby: { config: RbConfig::CONFIG } })
      return exception, attrs
    end
  end
end
