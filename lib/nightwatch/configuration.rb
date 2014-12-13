require 'singleton'
require 'nightwatch/mongo'

module Nightwatch
  def self.configure(&block)
    Configuration.instance.instance_eval(&block)
  end

  class Configuration
    include Singleton

    def initialize
      @logger = Mongo.new
    end

    attr_accessor :logger
  end
end
