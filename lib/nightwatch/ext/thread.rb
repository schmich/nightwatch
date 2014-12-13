class Thread
  initialize_method = instance_method(:initialize)

  define_method :initialize do |*args, &orig_block|
    block = proc do |*block_args|
      begin
        orig_block.call(*block_args)
      ensure
        if $!
          Nightwatch::ExceptionManager.instance.add_exception($!)
        end
      end
    end

    initialize_method.bind(self).call(*args, &block)
  end
end
