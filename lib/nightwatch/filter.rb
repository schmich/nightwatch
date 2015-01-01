require 'set'

module Nightwatch
  class DuplicateFilter
    def initialize
      @ids = Set.new
    end

    def exception(exception, attrs)
      if @ids.add?(exception.object_id)
        return exception, attrs
      else
        nil
      end
    end
  end
end
