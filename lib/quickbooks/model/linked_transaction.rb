module Quickbooks
  module Model
    class LinkedTransaction < BaseModel
      ## NOT SURE IF I NEED THIS
      XML_COLLECTION_NODE = "LinkedTransaction"
      XML_NODE = "LinkedTransaction"

      xml_accessor :txn_id, :from => 'TxnId'
      xml_accessor :txn_type, :from => 'TxnType'
      xml_accessor :txn_line_id, :from => 'TxnLineId'
    end
  end
end
