module Columbo
  class Configuration
    attr_accessor :amqp, :logger, :system, :client

    def initialize
      @system = OpenStruct.new
      @logger = Logger.new(STDOUT)
    end
  end
end
