# coding: utf-8
require 'spec_helper'

describe Mog::Error do

  def resp(status)
    { :status => status.to_s }
  end

  describe '.from_response' do

    it '2xx,3xxの場合は何も返さない' do
      (200..399).each do |status|
        expect(Mog::Error.from_response(resp(status))).to be_nil
      end
    end

    it '400の時はBadRequestを返す' do
      expect(Mog::Error.from_response(resp(400)).class).to eq Mog::BadRequest
    end

    it '404の時はInvalidTokenを返す' do
      expect(Mog::Error.from_response(resp(404)).class).to eq Mog::NotFound
    end

    it '400,404以外の4xxエラーの場合はClientErrorを返す' do
      (400..499).each do |status|
        next if [400,404].include? status
        expect(Mog::Error.from_response(resp(status)).class).to eq Mog::ClientError
      end
    end

    it '5xxエラーの場合はServerErrorを返す' do
      (500..599).each do |status|
        expect(Mog::Error.from_response(resp(status)).class).to eq Mog::ServerError
      end
    end
  end

  it '元のレスポンスが取得できる' do
    response = resp(400)
    expect(Mog::Error.new(response).response).to eq response
  end

  it '元のステータスコードが取得できる' do
    expect(Mog::Error.new(resp(400)).status).to eq 400
  end

end
