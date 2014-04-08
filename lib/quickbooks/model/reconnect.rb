module Quickbooks
  module Model
    class Reconnect < BaseModel
      XML_NODE = "ReconnectResponse"

      xml_name XML_NODE
      xml_accessor :error_message, :from => "ErrorMessage", :as => String
      xml_accessor :error_code, :from => "ErrorCode", :as => Integer
      xml_accessor :oauth_token, :from => "OAuthToken", :as => String
      xml_accessor :oauth_secret, :from => "OAuthTokenSecret", :as => String
    end
  end
end
