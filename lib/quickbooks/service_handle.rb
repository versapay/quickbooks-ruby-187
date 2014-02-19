module Quickbooks
  class ServiceHandle
    attr_reader :intuit_token, :intuit_secret, :intuit_realm

    def initialize(oauth_consumer, intuit_token, intuit_secret, intuit_realm)
      @oauth_consumer = oauth_consumer
      @intuit_secret = intuit_secret
      @intuit_token = intuit_token
      @intuit_realm = intuit_realm
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(@oauth_consumer, @intuit_token, @intuit_secret)
    end

    %w(account bill bill_payment company_info credit_memo customer employee
estimate invoice item payment payment_method purchase purchase_order sales_receipt service_crud
tax_rate term vendor vendor_credit).each do |service_name|
      ivar_name = "#{service_name}_service"
      eval(
        <<-EOM
  def #{ivar_name}
    unless @#{ivar_name}
      @#{ivar_name} = Quickbooks::Service::#{service_name.camelize}.new
      @#{ivar_name}.company_id = @intuit_realm
      @#{ivar_name}.access_token = access_token
    end
    @#{ivar_name}
  end
EOM
)
    end
  end
end
