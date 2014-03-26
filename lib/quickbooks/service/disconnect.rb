module Quickbooks
  module Service
    class Disconnect < BaseService
      UriForDisconnect = "https://appcenter.intuit.com/api/v3/connection/disconnect"

      def disconnect
        do_http_get(UriForDisconnect)
      end
    end
  end
end
