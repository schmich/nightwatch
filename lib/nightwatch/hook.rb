module Nightwatch
  class Hook
    def initialize(klass, method, &impl)
      @klass = klass
      @method = method

      @new_impl = impl
      @orig_impl = nil

      apply
    end

    def apply
      return if @orig_impl

      method = @method
      new_impl = @new_impl

      @orig_impl = @klass.class_eval do
        orig_impl = instance_method(method)
          
        define_method method do |*args, &block|
          bound_method = orig_impl.bind(self)
          self.instance_exec(bound_method, *args, block, &new_impl)
        end

        orig_impl
      end
    end

    def remove
      return if !@orig_impl

      method = @method
      orig_impl = @orig_impl

      @klass.class_eval do
        define_method method, orig_impl
      end

      @orig_impl = nil
    end
  end
end
