module Quickbooks
  module Service
    class Reconnect < BaseService
      UriForReconnect = "https://appcenter.intuit.com/api/v3/connection/reconnect"

      def reconnect
        model.from_xml(parse_singular_entity_response(do_http_get(UriForReconnect)))
      end

      def model
        Quickbooks::Model::Reconnect
      end
    end
  end
end
