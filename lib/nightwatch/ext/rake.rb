module Nightwatch
  class Rake
    def initialize
      # TODO: Do this in such a way that is undoable.
      require 'nightwatch/ext/rake_methods'
    end

    def exception(exception, record)
      if exception.is_a? SystemExit
        nil
      else
        return exception, record
      end
    end
  end
end
