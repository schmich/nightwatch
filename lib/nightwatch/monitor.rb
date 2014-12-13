require 'socket'
require 'singleton'
require 'rbconfig'
require 'nightwatch/configuration'
require 'nightwatch/ext/thread'

module Nightwatch
  class ExceptionManager
    include Singleton

    def self.absolute_path(file)
      File.absolute_path(file).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    end

    @@argv = Array.new(ARGV)
    @@script = absolute_path($0)

    def initialize
      @exceptions = {}
      @config = Configuration.instance
    end

    def add_exception(exception)
      Configuration.instance.filters.each do |filter|
        exception = filter.apply(exception)
        break if !exception
      end

      if exception
        @exceptions[exception.object_id] = [exception, stack(exception), Time.now.to_i]
      end
    end

    def commit!
      host = Socket.gethostname
      env = Hash[ENV.to_a]

      @exceptions.each do |id, info|
        exception, stack, ticks = info
        klass = exception.class.name

        record = {
          class: klass,
          message: exception.to_s,
          script: @@script,
          argv: @@argv,
          pid: $$,
          env: env,
          config: RbConfig::CONFIG,
          host: host,
          stack: stack,
          timestamp: ticks
        }

        @config.logger.log(record)
      end
    end

    private

    def stack(exception)
      stack = []
      if exception.respond_to? :backtrace_locations
        exception.backtrace_locations.each do |location|
          stack << {
            label: location.label,
            path: self.class.absolute_path(location.absolute_path),
            line: location.lineno
          }
        end
      else
        exception.backtrace.each do |location|
          location.match(/^(.+?):(\d+)(|:in `(.+)')$/)
          stack << {
            label: $4,
            path: self.class.absolute_path($1),
            line: $2.to_i
          }
        end
      end

      stack
    end
  end
end

at_exit do
  if $!
    Nightwatch::ExceptionManager.instance.add_exception($!)
  end

  Nightwatch::ExceptionManager.instance.commit!
end
