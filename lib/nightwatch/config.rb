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

    def use(klass, *args)
      instance = klass.new(*args)
      @stack << instance
    end
  end
end
