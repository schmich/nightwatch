require 'nightwatch/hook'

module Nightwatch
  class Rake
    def initialize
      @app_hook = Hook.new(::Rake::Application, :top_level) do |orig, *args, block|
        begin
          orig.call(*args, &block)
        ensure
          Nightwatch::Monitor.instance.add_exception($!) if $!
        end
      end

      @task_hook = Hook.new(::Rake::Task, :execute) do |orig, *args, block|
        begin
          orig.call(*args, &block)
        ensure
          if $!
            record = { ruby: { rake: { task: self.name } } }
            Nightwatch::Monitor.instance.add_exception($!, record)
          end
        end
      end
    end

    def exception(exception, record)
      if exception.is_a? SystemExit
        nil
      else
        return exception, record
      end
    end
  end
end
