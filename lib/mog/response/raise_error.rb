require 'faraday'
require 'mog/error'

module Mog
  module Response

    class RaiseError < Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = Mog::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
