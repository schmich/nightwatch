module Nightwatch
  class Config
    def initialize
      @logger = Plugins.new
      @middleware = Plugins.new
    end

    attr_accessor :logger
    attr_accessor :middleware
  end

  class Plugins
    include Enumerable

    def initialize
      @stack = []
    end

    def each(*args, &block)
      @stack.each(*args, &block)
    end

    def use(new_class, *args, &block)
      instance = new_class.new(*args, &block)
      @stack << instance
    end

    def use_before(before_class, new_class, *args, &block)
      index = index(before_class)

      instance = new_class.new(*args, &block)
      @stack.insert(index, instance)
    end

    def use_after(after_class, new_class, *args, &block)
      index = index(after_class)

      instance = new_class.new(*args, &block)
      @stack.insert(index + 1, instance)
    end

    def remove(klass)
      @stack.reject! { |plugin| plugin.class == klass }
    end

    def swap(out_class, new_class, *args, &block)
      index = index(out_class)
      @stack.delete_at(index)

      instance = new_class.new(*args, &block)
      @stack.insert(index, instance)
    end

    private

    def index(find_class)
      index = @stack.index { |plugin| plugin.class == find_class }
      if !index
        raise Nightwatch::Error, "#{find_class} not found."
      end

      index
    end
  end
end
