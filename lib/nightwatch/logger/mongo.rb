require 'mongo'

module Nightwatch
  class MongoLogger
    # TODO: Allow users to specify client (e.g. Nightwatch::Mongo.new(client: mongo_client))
    # TODO: Raise error if one of :host/:port or :client is not specified
    def initialize(opts = {})
      @host = opts[:host] || '127.0.0.1'
      @port = opts[:port] || 27017
      @database = opts[:database] || 'nightwatch'
    end

    def log(record)
      collection.insert(record)
    end

    private

    def collection
      @collection ||= begin
        mongo = Mongo::MongoClient.new(@host, @port)
        mongo[@database]['exceptions']
      end
    end
  end
end
