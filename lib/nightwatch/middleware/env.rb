require 'deep_merge'

module Nightwatch
  class Env
    def exception(exception, record)
      env = Hash[ENV.to_a]
      return exception, record.deep_merge({ env: env })
    end
  end
end
