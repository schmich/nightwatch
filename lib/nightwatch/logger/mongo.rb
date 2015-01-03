require 'mongo'

module Nightwatch
  class MongoLogger
    def initialize(opts = {})
      @client = opts[:client]
      @host = opts[:host] || '127.0.0.1'
      @port = opts[:port] || 27017
      @database = opts[:database] || 'nightwatch'
    end

    def log(records)
      docs = []
      records.each do |record|
        # We duplicate records since Mongo adds additional
        # data of its own when inserting the document.
        docs << record.dup
      end

      collection.insert(docs)
    end

    private

    def collection
      @collection ||= begin
        @client ||= Mongo::MongoClient.new(@host, @port)
        @client[@database]['events']
      end
    end
  end
end
