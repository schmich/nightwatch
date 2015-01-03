require 'redis'
require 'json'

module Nightwatch
  class RedisLogger
    def initialize(opts = {})
      @opts = opts
      @client = opts[:client]

      @list = opts[:list]
      @channel = opts[:channel]

      if !@list && !@channel
        raise Error, ':list or :channel must be specified.'
      end
    end

    def log(records)
      json = records.map { |record| JSON.dump(record) }

      if @list
        client.lpush(@list, json)
      end

      if @channel
        client.publish(@channel, json)
      end
    end

    private

    def client
      @client ||= begin
        Redis.new(@opts)
      end 
    end
  end
end
