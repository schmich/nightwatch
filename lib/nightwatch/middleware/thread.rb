require 'nightwatch/hook'

module Nightwatch
  class Thread
    def initialize
      @thread_hook = Hook.new(::Thread, :initialize) do |orig, *args, block|
        hooked_block = proc do |*block_args|
          Nightwatch.monitor do
            block.call(*block_args)
          end
        end

        orig.call(*args, &hooked_block)
      end
    end

    def exception(exception, record)
      return exception, record
    end
  end
end
