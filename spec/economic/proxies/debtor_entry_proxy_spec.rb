require "./spec/spec_helper"

describe Economic::DebtorEntryProxy do
  let(:session) { make_session }
  subject { Economic::DebtorEntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe "#find_by_invoice_number" do
    it "should be able to find multiple debtor entries" do
      mock_request(
        "DebtorEntry_FindByInvoiceNumber",
        {"from" => "123", "to" => "456"},
        :many
      )
      expect(subject.find_by_invoice_number("123", "456")).to eq([1, 2])
    end

    it "should be able to find debtor entries with one invoice id" do
      mock_request(
        "DebtorEntry_FindByInvoiceNumber",
        {"from" => "123", "to" => "123"},
        :many
      )
      expect(subject.find_by_invoice_number("123")).to eq([1, 2])
    end

    it "should handle a single serial number in the response" do
      stub_request("DebtorEntry_FindByInvoiceNumber", nil, :single)
      expect(subject.find_by_invoice_number("123")).to eq([1])
    end
  end

  describe "#match" do
    it "should match two debtor entries by serial numbers" do
      stub_request(
        "DebtorEntry_MatchEntries",
        {:entries => {
          "DebtorEntryHandle" => [
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
    it "should return Economic::DebtorEntry" do
      expect(
        Economic::DebtorEntryProxy.entity_class
      ).to eq(Economic::DebtorEntry)
    end
  end
end
