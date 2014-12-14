require 'set'

module Nightwatch
  class DuplicateFilter
    def initialize
      @ids = Set.new
    end

    def apply(exception)
      if @ids.add?(exception.object_id)
        exception
      else
        nil
      end
    end
  end
end
