require 'sinatra'
require 'sinatra/json'
require 'mongo'

set :port, 3000

mongo = Mongo::MongoClient.new
exceptions = mongo['nightwatch']['exceptions']

get '/' do
  erb :index
end

get '/exceptions' do
  json exceptions.find.to_a
end
