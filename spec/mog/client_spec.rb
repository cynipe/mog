# coding: utf-8
require 'spec_helper'

describe Mog::Client do

  describe "module configuration" do

    before do
      Mog.reset!
      Mog.configure do |config|
        Mog::Configuration.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      Mog.reset!
    end

    it "inherits the module configuration" do
      client = Mog::Client.new
      Mog::Configuration.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq "Some #{key}"
      end
    end

    describe "with class level configuration" do

      before do
        @opts = {
          :api_endpoint => 'https://your-api.example.org',
          :api_version => 'v3',
        }
      end

      it "overrides module configuration" do
        client = Mog::Client.new(@opts)
        expect(client.api_endpoint).to eq 'https://your-api.example.org/'
        expect(client.api_version).to eq 'v3'
      end

      it "can set configuration after initialization" do
        client = Mog::Client.new
        client.configure do |config|
          @opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end
        expect(client.api_endpoint).to eq 'https://your-api.example.org/'
        expect(client.api_version).to eq 'v3'
      end

    end
  end

  it 'uses useragent header as specified' do
    client = Mog::Client.new
    expect(client.send(:agent).headers[:user_agent]).to eq client.instance_variable_get(:"@user_agent")
  end
end
