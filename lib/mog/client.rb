require 'faraday'
require 'faraday_middleware'
require 'mog/configuration'
require 'mog/defaults'

module Mog
  class Client
    include Mog::Configuration

    def initialize(options = {})
      Mog::Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || Mog.instance_variable_get(:"@#{key}"))
      end
    end

    def some_api(hoge, foo)
      response = agent.post("/api/#{api_version}/some_api", { 'hoge' => hoge, 'foo' => foo })
      # 必要ならここでそれっぽいクラスに移し替える
      response.body
    end

    # and so on...

    private
    def agent
      @agent ||= begin
        faraday_opts = @connection_options.dup
        faraday_opts[:builder] = @middleware
        Faraday.new(api_endpoint, faraday_opts)
      end
    end
  end
end
