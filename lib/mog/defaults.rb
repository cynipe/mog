require 'mog/response/raise_error'

module Mog

  # デフォルト設定
  module Defaults

    API_ENDPOINT = 'https://your-api.example.org'.freeze
    API_VERSION  = 'v1'.freeze
    USER_AGENT   = "Mog Gem #{Mog::VERSION}".freeze

    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      builder.use Mog::Response::RaiseError
      builder.use Faraday::Response::Logger if ENV['DEBUG']
      builder.use Faraday::Request::UrlEncoded
      builder.response :json, :content_type => /\bjson/
      builder.adapter Faraday.default_adapter
    end

    class << self

      def options
        Hash[ Mog::Configuration.keys.map {|k| [k, send(k)]} ]
      end

      def api_endpoint
        ENV['MOG_API_ENDPOINT'] || API_ENDPOINT
      end

      def api_version
        ENV['MOG_API_VERSION'] || API_VERSION
      end

      # 使い手毎にUAを差し替えるのが望ましい
      def user_agent
        ENV['MOG_USER_AGENT'] || USER_AGENT
      end

      # faradayに渡すデフォルトオプション
      def connection_options
        {
          :timeout      => 1,
          :open_timeout => 1,
          :headers      => { :user_agent   => user_agent }
        }
      end

      def middleware
        MIDDLEWARE
      end
    end
  end
end
