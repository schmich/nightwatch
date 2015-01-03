require 'uri'
require 'net/http'
require 'json'

module Nightwatch
  class SlackLogger
    def initialize(opts = {})
      @url = opts[:url]
      @format = opts[:format] || :long

      if ![:short, :long].include?(@format)
        raise Error, ":format must be either :short or :long."
      end

      if !@url
        raise Error, 'Webhook URL is required.'
      end
    end

    def log(records)
      texts = []

      if @format == :short
        method = :short_format
      else
        method = :long_format
      end

      uri = URI(@url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')

      req = Net::HTTP::Post.new(uri)
      req.content_type = 'application/json'

      self.send(method, records) do |payload|
        req.body = JSON.dump(payload)
        resp = http.request(req)
        puts resp
      end
    end

    private

    def short_format(records)
      texts = []

      records.each do |record|
        exception = record[:exception]
        klass = exception[:class]
        message = exception[:message]

        text = "`#{klass}`: #{message}"

        top = exception[:stack].first
        if top
          text += " at `#{top[:label]}` in #{top[:path]}:#{top[:line]}"
        end

        text += " on #{record[:host][:name]}"

        texts << text
      end

      payload = {
        username: 'Nightwatch',
        text: texts.join("\n")
      }

      yield payload
    end

    def long_format(records)
      records.each do |record|
        exception = record[:exception]
        klass = exception[:class]
        message = exception[:message]

        stack = exception[:stack]
        stack_value = stack.map do |frame|
          "`#{frame[:label]}` in #{frame[:path]}:#{frame[:line]}"
        end.join("\n")

        script = "#{record[:process][:script]} #{record[:process][:argv].join(' ')}",
        time = Time.at(record[:timestamp]).strftime('%a, %d %b %Y, %T %z')
        pretext = "`#{klass}`: #{message}"

        payload = {
          username: 'Nightwatch',
          attachments: [{
            mrkdwn_in: ['pretext', 'fields', 'fallback'],
            text: '',
            fallback: pretext,
            pretext: pretext,
            fields: [{
              title: 'Stack',
              value: stack_value,
              short: true
            }, {
              title: 'Host',
              value: record[:host][:name],
              short: true
            }, {
              title: 'Script',
              value: script,
              short: true
            }, {
              title: 'Time',
              value: time,
              short: true
            }]
          }]
        }

        yield payload
      end
    end
  end
end
