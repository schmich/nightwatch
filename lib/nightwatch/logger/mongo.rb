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
      # We duplicate the record since Mongo adds additional
      # data of its own before inserting the document.
      collection.insert(record.dup)
    end

    private

    def collection
      @collection ||= begin
        mongo = Mongo::MongoClient.new(@host, @port)
        mongo[@database]['events']
      end
    end
  end
end
