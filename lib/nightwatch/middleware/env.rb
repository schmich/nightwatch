require 'deep_merge'

module Nightwatch
  class Env
    def exception(exception, record)
      env = {
        process: {
          env: Hash[ENV.to_a]
        }
      }
      return exception, record.deep_merge(env)
    end
  end
end
