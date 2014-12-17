require 'set'

module Nightwatch
  class DuplicateFilter
    def initialize
      @ids = Set.new
    end

    def apply(exception, attrs)
      if @ids.add?(exception.object_id)
        return exception, attrs
      else
        nil
      end
    end
  end
end
