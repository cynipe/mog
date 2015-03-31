
module Mog

  module Configuration

    VALID_OPTS = [
      :api_endpoint,
      :api_version,
      :user_agent,
      :connection_options,
      :middleware
    ].freeze

    VALID_OPTS.each {|opt| attr_accessor opt }

    def self.keys
      VALID_OPTS
    end

    def configure
      yield self
    end

    def reset!
      Mog::Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", Mog::Defaults.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, '') # trailing slash対策
    end

    private
    def options
      Hash[Mog::Configuration.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end
