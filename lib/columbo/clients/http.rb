require 'net/http'

module Columbo
  module Client
    class HTTP
      DEFAULT_OPEN_TIMEOUT = 2
      DEFAULT_READ_TIMEOUT = 2

      def initialize(push_url, opts = {})
        raise ArgumentError.new('Please provide a push url') if push_url.nil?

        @push_url = push_url
        @open_timeout = opts[:open_timeout] || DEFAULT_OPEN_TIMEOUT
        @read_timeout = opts[:read_timeout] || DEFAULT_READ_TIMEOUT
      end

      def publish(event, options = nil)
        begin
          publish_event(event)
        rescue Exception => e
          Columbo.logger.warn(e.message)
          false
        end
      end

      def publish!(event, options = nil)
        publish_event(event)
      end

      private

      def publish_event(event)
        post(@push_url, event.to_json)
      end

      def post(uri, body)
        uri = URI(uri)
        path = uri.path.empty? ? '/' : uri.path

        proxy = URI.parse(ENV['HTTP_PROXY'] || ENV['http_proxy']) rescue nil
        proxy_host = proxy.nil? ? nil : proxy.host
        proxy_port = proxy.nil? ? nil : proxy.port
        http = Net::HTTP.new(uri.host, uri.port, proxy_host, proxy_port)
        http.use_ssl = uri.instance_of?(URI::HTTPS)
        http.open_timeout = @open_timeout
        http.read_timeout = @read_timeout

        headers = {
          'Content-Type' => 'application/json',
          'User-Agent' => "Columbo-Ruby-Client/#{Columbo::VERSION}"
        }
        response = http.post(path, body, headers)
        response.kind_of?(Net::HTTPSuccess) ? true : response.error!
      end
    end
  end
end
