require 'json'
require 'singleton'
require 'logging'
require 'active_record'

require 'tyrion/wrapped_logging'

module Tyrion
  class Config
    attr_reader :logger, :api_logger, :snow, :num_of_threads

    include Singleton

    LOG_FILE_PATH = File.expand_path("../../../logs/tyrion_main.log", __FILE__)
    API_LOG_FILE_PATH = File.expand_path("../../../logs/tyrion_api.log", __FILE__)

    def initialize
      Logging.color_scheme(
        'bright',
        :levels => {
          :info  => :green,
          :warn  => :yellow,
          :error => :red,
          :fatal => [:white, :on_red]
        },
        :date => :blue,
        :logger => :cyan,
        :message => :magenta
      )

      @logger = get_logger('main_logger', LOG_FILE_PATH)
      @api_logger = get_logger('api_logger', API_LOG_FILE_PATH,)

      ActiveRecord::Base.establish_connection(
        :adapter => 'mysql2',
        :database  => 'dev',
        :username => 'root',
        :password => 'root',
        :host => 'db'
      )

      @logger.debug "initialized Config"
    end

    private

    def get_logger(name, file_name)
      logger_obj = Tyrion::WrappedLogging.new(Logging.logger[name])
      logger_obj.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file(
          'file',
          :filename => file_name,
          :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l %c: %m \n')
        )
      )
      logger_obj.level = :info

      logger_obj
    end
  end
end
