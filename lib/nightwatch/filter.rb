require 'set'

module Nightwatch
  class DuplicateFilter
    def initialize
      @ids = Set.new
    end

    def exception(exception, record)
      if @ids.add?(exception.object_id)
        return exception, record
      else
        nil
      end
    end
  end
end
