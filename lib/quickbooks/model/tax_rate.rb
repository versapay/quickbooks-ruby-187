module Quickbooks
  module Model
    class TaxRate < BaseModel
      REST_RESOURCE = "tax_rate"
      XML_NODE = "TaxRate"

      xml_accessor :id, :from => 'Id', :as => Integer
      xml_accessor :sync_token, :from => 'SyncToken', :as => Integer
      xml_accessor :meta_data, :from => 'MetaData', :as => MetaData
      xml_accessor :name, :from => 'Name'
      xml_accessor :description, :from => 'Description'
      xml_accessor :active, :from => 'Active'
      xml_accessor :rate_value, :from => 'RateValue', :as => BigDecimal
      xml_accessor :special_tax_type, :from => 'SpecialTaxType'
      xml_accessor :display_type, :from => 'DisplayType'

      reference_setters :agency_ref

    end
  end
end
