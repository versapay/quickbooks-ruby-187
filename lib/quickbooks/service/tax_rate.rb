module Quickbooks
  module Service
    class TaxRate < Base::Service
      include ServiceCrud

      def default_model_query
        "SELECT * FROM TaxRate"
      end

      def model
        Quickbooks::Model::TaxRate
      end

      def search_name_query(name)
        "SELECT * FROM TaxRate WHERE Name = '#{name}'"
      end
    end
  end
end
