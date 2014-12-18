require 'monitor'

Kernel.at_exit do
  Nightwatch::Monitor.instance.commit!
end
