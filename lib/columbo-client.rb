require 'json'
require 'logger'
require 'columbo/version'
require 'columbo/configuration'
require 'columbo/clients/amqp'
require 'columbo/clients/http'

module Columbo
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def logger
      @logger ||= configuration.logger
    end

    def configure
      yield(configuration) if block_given?
    end

    def client
      @client ||= configuration.client
    end
  end
end
