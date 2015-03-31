# coding: utf-8
require 'spec_helper'

describe Mog do
  before do
    Mog.reset!
  end

  after do
    Mog.reset!
  end

  it 'sets defaults' do
    Mog::Configuration.keys.each do |key|
      expect(Mog.instance_variable_get(:"@#{key}")).to eq Mog::Defaults.send(key)
    end
  end

  describe '.client' do
    it 'creates an Mog::Client' do
      expect(Mog.client).to be_kind_of Mog::Client
    end

    it 'caches the client' do
      expect(Mog.client).to eq Mog.client
    end

  end

  describe '.configure' do
    Mog::Configuration.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Mog.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Mog.instance_variable_get(:"@#{key}")).to eq key
      end
    end
  end
end
