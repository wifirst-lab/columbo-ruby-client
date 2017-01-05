require 'bunny'

module Columbo
  module Client
    class AMQP
      def initialize(connection_uri)
        @connection_uri = connection_uri
      end

      def publish(event, options = {})
        begin
          publish_event(event, options)
          true
        rescue Exception => e
          Columbo.logger.warn(e.message)
          false
        end
      end

      def publish!(event, options = {})
        publish_event(event, options)
      end

      def exchange(name)
        raise ArgumentError, 'Please provide a name for the AMQP exchange' if name.nil?

        @channel = connection.create_channel

        if block_given?
          exchange_options = OpenStruct.new(arguments: {})
          yield exchange_options

          type = exchange_options.delete_field(:type)
          @exchange = @channel.send(type, name, exchange_options.to_h)
        else
          raise ArgumentError, 'Please provide a block to configure the exchange'
        end
      end

      private

      def publish_event(event, options = {})
        raise 'No exchange has been configurated for the Columbo Client' if @exchange.nil?

        @exchange.publish(event.to_json, options)
      end

      def connection
        @connection ||= Bunny.new(@connection_uri).start
      end
    end
  end
end
