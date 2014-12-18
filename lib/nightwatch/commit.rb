require 'monitor'

Kernel.at_exit do
  Nightwatch::ExceptionManager.instance.commit!
end
