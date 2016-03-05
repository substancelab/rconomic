require "./spec/spec_helper"

describe Economic::CreditorEntryProxy do
  let(:session) { make_session }
  subject { Economic::CreditorEntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe "#find_by_invoice_number" do
    it "should be able to find multiple creditor entries" do
      mock_request("CreditorEntry_FindByInvoiceNumber", {"invoiceNumber" => "123"}, :many)
      expect(subject.find_by_invoice_number("123")).to eq([1, 2])
    end

    it "should handle a single serial number in the response" do
      stub_request("CreditorEntry_FindByInvoiceNumber", nil, :single)
      expect(subject.find_by_invoice_number("123")).to eq([1])
    end
  end

  describe "#find" do
    it "should get a creditor entry by serial number" do
      mock_request("CreditorEntry_GetData", {"entityHandle" => {"SerialNumber" => "123"}}, :success)
      expect(subject.find("123")).to be_instance_of(Economic::CreditorEntry)
    end
  end

  describe "#match" do
    it "should match two creditor entries by serial numbers" do
      stub_request(
        "CreditorEntry_MatchEntries",
        {:entries => {
          "CreditorEntryHandle" => [
            {"SerialNumber" => 1},
            {"SerialNumber" => 2}
          ]
        }},
        :success
      )
      subject.match(1, 2)
    end
  end

  describe "#entity_class" do
    it "should return Economic::CreditorEntry" do
      expect(Economic::CreditorEntryProxy.entity_class).to eq(Economic::CreditorEntry)
    end
  end
end
