require 'sinatra'
require 'sinatra/json'
require 'mongo'

module Nightwatch
  class Server < Sinatra::Application
    set :run, false
    set :server, 'thin'

    # TODO: Allow server configuration via command-line or settings file.
    mongo = Mongo::MongoClient.new
    exceptions = mongo['nightwatch']['exceptions']

    get '/' do
      erb :index
    end

    get '/exceptions' do
      json exceptions.find.to_a
    end
  end
end
