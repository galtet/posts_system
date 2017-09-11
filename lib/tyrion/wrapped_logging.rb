require 'logging'

module Tyrion
  class WrappedLogging
    def initialize(logger)
      @logger = logger
    end

    def method_missing(name, *args)
      @logger.send(name, *args)
    end

    # for rack hack (see config.ru)
    def info(*args)
      @logger.send(:info, *args)
    end

    def exception(header, e)
      @logger.error header + " : " + e.message.to_s
      @logger.error "Backtrace:"
      e.backtrace.each { |b| @logger.error "> #{b}" }
    end
  end
end
