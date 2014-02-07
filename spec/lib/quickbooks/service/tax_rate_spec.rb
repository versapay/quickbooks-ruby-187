describe Quickbooks::Service::TaxRate do
  before(:all) do
    construct_service :tax_rate
  end

  it "can query for tax rates" do
    xml = fixture("tax_rates.xml")
    stub_request(:get, @service.url_for_query, ["200", "OK"], xml, true)
    tax_rates = @service.query
    tax_rates.count.should == 1
    tax_rate = tax_rates.entries.first
    tax_rate.name.should == "Mountain View"
  end
end
