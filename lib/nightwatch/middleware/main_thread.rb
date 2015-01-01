module Nightwatch
  class MainThread
    def initialize
      Kernel.at_exit do
        Nightwatch::Monitor.instance.add_exception($!) if $!
      end
    end

    def exception(exception, record)
      return exception, record
    end
  end
end
