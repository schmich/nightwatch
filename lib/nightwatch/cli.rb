require 'nightwatch/server'
require 'nightwatch/version'
require 'thor'
require 'launchy'

module Nightwatch
  class CommandLine < Thor
    desc '[--bind <ip>] [--port <port>]', 'Start dashboard server.'
    options :port => :integer, :host => :string
    option :version, :type => :boolean, :aliases => :v
    def start
      if options[:version]
        version
        return
      end

      bind = options[:bind] || '0.0.0.0'  
      port = options[:port] || 3000
 
      server = Nightwatch::Server
      server.set :bind, bind
      server.set :port, port
      server.run!
    end

    desc '-v|--version', 'Print version.'
    def version
      puts "Nightwatch #{Nightwatch::VERSION}"
    end

    default_task :start
  end
end
