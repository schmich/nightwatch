module Rake
  class Application
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
  end

  class Task
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
  end
end

