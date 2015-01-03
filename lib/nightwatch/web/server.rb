require 'sinatra'
require 'sinatra/json'
require 'mongo'

module Nightwatch
  class Server < Sinatra::Application
    set :run, false
    set :server, 'thin'

    # TODO: Allow server configuration via command-line or settings file.
    mongo = Mongo::MongoClient.new
    events = mongo['nightwatch']['events']

    get '/' do
      erb :index
    end

    get '/events' do
      json events.find.to_a
    end

    get '/events/summary' do
      json events.find({}, fields: [
        'exception.class',
        'exception.message',
        'host.name',
        'timestamp'
      ]).to_a
    end

    get '/events/:id' do
      json events.find(_id: BSON::ObjectId(params[:id])).first
    end
  end
end
