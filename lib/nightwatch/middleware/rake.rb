module Nightwatch
  class Rake
    def initialize
      @orig_top_level_method = nil
      @orig_execute_method = nil

      add_hooks
    end

    def exception(exception, record)
      if exception.is_a? SystemExit
        nil
      else
        return exception, record
      end
    end

    private

    def add_hooks
      @orig_top_level_method = ::Rake::Application.class_eval do
        top_level_method = instance_method(:top_level)

        define_method :top_level do |*args, &block|
          begin
            top_level_method.bind(self).call(*args, &block)
          ensure
            if $!
              Nightwatch::Monitor.instance.add_exception($!)
            end
          end
        end

        top_level_method
      end

      @orig_execute_method = ::Rake::Task.class_eval do
        execute_method = instance_method(:execute)

        define_method :execute do |*args, &block|
          begin
            execute_method.bind(self).call(*args, &block)
          ensure
            if $!
              record = { ruby: { rake: { task: self.name } } }
              Nightwatch::Monitor.instance.add_exception($!, record)
            end
          end
        end

        execute_method
      end
    end

    def remove_hooks
      orig_top_level_method = @orig_top_level_method
      orig_execute_method = @orig_execute_method

      ::Rake::Application.class_eval do
        define_method :top_level, orig_top_level_method
      end

      ::Rake::Task.class_eval do
        define_method :execute, orig_execute_method
      end
    end
  end
end
