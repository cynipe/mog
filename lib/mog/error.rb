
module Mog

  class Error < StandardError

    def self.from_response(response)
      status  = response[:status].to_i

      if klass =  case status
                  when 400      then Mog::BadRequest
                  when 404      then Mog::NotFound
                  when 400..499 then Mog::ClientError
                  when 500..599 then Mog::ServerError
                  end
        klass.new(response)
      end
    end

    attr_reader :response

    def initialize(response = nil)
      @response = response
    end

    def status
      @response[:status].to_i
    end

  end

  ClientError = Class.new(Error)

  BadRequest   = Class.new(Error)
  InvalidToken = Class.new(ClientError)

  ServerError = Class.new(Mog::Error)

end
