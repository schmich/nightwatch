require 'singleton'
require 'nightwatch/mongo'
require 'nightwatch/filter'

module Nightwatch
  def self.configure(&block)
    Configuration.instance.instance_eval(&block)
  end

  class Configuration
    include Singleton

    def initialize
      @logger = Mongo.new
      @filters = [AcceptFilter.new]
    end

    attr_accessor :logger
    attr_accessor :filters
  end
end
