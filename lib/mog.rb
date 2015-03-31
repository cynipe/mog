# coding: utf-8
require 'mog/version'
require 'mog/client'

module Mog

  class << self
    include Mog::Configuration

    def client
      @client ||= Mog::Client.new(options)
    end

    # @private
    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    # @private
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

  private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end

end

# setup defaults
Mog.setup
