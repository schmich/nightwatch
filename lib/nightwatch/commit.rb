require 'monitor'

Kernel.at_exit do
  Nightwatch.instance.commit!
end
