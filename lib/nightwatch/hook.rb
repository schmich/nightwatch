module Nightwatch
  class Hook
    def initialize(klass, method, &impl)
      @klass = klass
      @method = method
      
      @orig_impl = klass.class_eval do
        orig_impl = instance_method(method)
          
        define_method method do |*args, &block|
          bound_method = orig_impl.bind(self)
          self.instance_exec(bound_method, *args, block, &impl)
        end

        orig_impl
      end
    end

    def remove
      method = @method
      orig_impl = @orig_impl

      @klass.class_eval do
        define_method method, orig_impl
      end
    end
  end
end
