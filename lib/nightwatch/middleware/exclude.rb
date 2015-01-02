require 'set'

module Nightwatch
  class Exclude
    def initialize(opts = {})
      classes = opts[:class] || []
      classes = [classes] if classes.is_a? Class

      modules = opts[:module] || []
      modules = [modules] if modules.is_a? Module

      filters = opts[:filter] || []
      @filters = filters.is_a?(Proc) ? [filters] : filters

      @classes = Set.new(classes)
      @modules = Set.new(modules)
    end

    def exception(exception, record)
      klass = exception.class

      if @classes.include?(klass)
        return nil
      end

      if !@modules.empty? && @modules.include?(class_module(klass))
        return nil
      end

      @filters.each do |filter|
        if filter.call(exception)
          return nil
        end
      end

      return exception, record
    end

    private
    
    def class_module(klass)
      name = klass.name
      separator = name.rindex('::')
      if !separator
        nil
      else
        module_name = name[0...separator]
        Kernel.const_get module_name
      end
    end
  end
end
