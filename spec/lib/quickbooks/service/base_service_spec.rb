describe Quickbooks::Service::BaseService do
  before do
    stub_const "Quickbooks::VERSION", "0.0.5"
  end

  describe "#url_for_query" do
    it "correctly encodes the query" do
      subject.realm_id = 1234
      query = "SELECT * FROM Customer where Name = 'John'"

      correct_url = "https://qb.sbfinance.intuit.com/v3/company/1234/query?query=SELECT%20*%20FROM%20Customer%20where%20Name%20=%20'John'"
      subject.url_for_query(query).should include(correct_url)
    end

    context 'logging' do
      before do
        construct_service :vendor
        stub_request(:get, @service.url_for_query, ["200", "OK"], fixture("vendors.xml"))
      end

      it "should not log by default" do
        Quickbooks.logger.should_receive(:info).never
        @service.query
      end

      it "should log if Quickbooks.log = true" do
        Quickbooks.log = true
        Quickbooks.logger.should_receive(:info).at_least(1)
        @service.query
        Quickbooks.log = false
      end
    end

  end

  it "Correctly handled an IntuitRequestException" do
    construct_service :base_service
    xml = fixture("customer_duplicate_error.xml")
    response = Struct.new(:plain_body, :code).new(xml, 400)
    expect{ @service.send(:check_response, response) }.to raise_error(Quickbooks::IntuitRequestException, /is already using this name/)
  end
end
