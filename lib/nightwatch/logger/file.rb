require 'json'

module Nightwatch
  class FileLogger
    def initialize(opts = {})
      file = opts[:file]
      if file.is_a? String
        @file = File.open(file, 'a+')
      elsif file.is_a? IO
        @file = file
      else
        raise RuntimeError, 'Invalid file. IO or string required.'
      end
    end

    def log(records)
      records.each do |record|
        @file.write(JSON.dump(record))
      end
    end
  end
end
