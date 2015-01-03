require 'faraday'
require 'json'

module Nightwatch
  class SlackLogger
    def initialize(opts = {})
      @url = opts[:url]

      if !@url
        raise Error, 'Webhook URL is required.'
      end
    end

    def log(records)
      conn = Faraday.new(:url => @url)

      records.each do |record|
        exception = record[:exception]
        klass = exception[:class]
        message = exception[:message]

        text = "#{klass}: #{message}"

        top = exception[:stack].first
        if top
          text += " at #{top[:label]} in #{top[:path]}:#{top[:line]}"
        end

        conn.post do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = JSON.dump({ username: 'Nightwatch', text: text })
        end
      end
    end
  end
end
