require 'socket'
require 'singleton'
require 'deep_merge'
require 'thread'
require 'nightwatch/config'

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
      @exceptions_lock = Mutex.new
      @config = Config.new
    end

    def config
      @config
    end

    def add_exception(exception, record = {})
      record = create_record(exception).deep_merge(record)

      @config.middleware.each do |middleware|
        exception, record = middleware.exception(exception, record)
        break if !exception
      end

      @exceptions_lock.synchronize do
        @exceptions << record if record
      end
    end

    def commit!
      to_log = nil
      @exceptions_lock.synchronize do
        to_log = @exceptions.dup
        @exceptions = []
      end

      @config.logger.each do |logger|
        logger.log(to_log)
      end
    end

    private

    def create_record(exception)
      return {
        exception: {
          class: exception.class.name,
          message: exception.to_s,
          stack: stack(exception)
        },
        process: {
          id: $$,
          script: @@script,
          argv: @@argv
        },
        host: {
          name: Socket.gethostname
        },
        runtime: {
          language: 'ruby'
        },
        timestamp: Time.now.to_i
      }
    end

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
        # TODO: Support alternate format: http://ruby-doc.org/core-2.1.1/Exception.html#method-i-backtrace
        # Method might be missing from backtrace information.
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
