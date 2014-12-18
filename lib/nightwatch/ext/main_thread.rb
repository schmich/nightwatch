Kernel.at_exit do
  if $!
    Nightwatch::ExceptionManager.instance.add_exception($!)
  end
end
