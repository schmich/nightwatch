require 'socket'
require 'singleton'
require 'deep_merge'
require 'nightwatch/configuration'
require 'nightwatch/ext/rb_config'

module Nightwatch
  def self.instance
    Monitor.instance
  end

  def self.configure(&block)
    self.instance.instance_eval(&block)
  end

  class Monitor
    include Singleton

    def self.absolute_path(file)
      File.absolute_path(file).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
    end

    @@argv = Array.new(ARGV)
    @@script = absolute_path($0)

    def initialize
      @exceptions = []
      @config = Configuration.new
    end

    def config
      @config
    end

    def add_exception(exception, attrs = {})
      @config.middleware.each do |middleware|
        exception, attrs = middleware.exception(exception, attrs)
        break if !exception
      end

      if exception
        @exceptions << [exception, attrs, Time.now.to_i]
      end
    end

    def commit!
      host = Socket.gethostname
      # TODO: Move to class variable or to exception occurrence.
      env = Hash[ENV.to_a]

      @exceptions.each do |info|
        exception, attrs, ticks = info
        stack = stack(exception)
        klass = exception.class.name

        record = {
          class: klass,
          message: exception.to_s,
          runtime: 'ruby',
          script: @@script,
          argv: @@argv,
          pid: $$,
          env: env,
          host: host,
          stack: stack,
          timestamp: ticks
        }.deep_merge(attrs)

        @config.logger.each do |logger|
          logger.log(record)
        end
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
