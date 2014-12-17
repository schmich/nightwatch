module Rake
  class Application
    top_level_method = instance_method(:top_level)

    define_method :top_level do |*args, &block|
      begin
        top_level_method.bind(self).call(*args, &block)
      ensure
        if $!
          Nightwatch::ExceptionManager.instance.add_exception($!)
        end
      end
    end
  end

  class Task
    execute_method = instance_method(:execute)

    define_method :execute do |*args, &block|
      begin
        execute_method.bind(self).call(*args, &block)
      ensure
        if $!
          attrs = { ruby: { rake: { task: self.name } } }
          Nightwatch::ExceptionManager.instance.add_exception($!, attrs)
        end
      end
    end
  end
end

module Nightwatch
  class RakeFilter
    def apply(exception, attrs)
      if exception.is_a? SystemExit
        nil
      else
        return exception, attrs
      end
    end
  end
end

Nightwatch::Configuration.instance.filters << Nightwatch::RakeFilter.new
