Kernel.at_exit do
  if $!
    Nightwatch::Monitor.instance.add_exception($!)
  end
end
