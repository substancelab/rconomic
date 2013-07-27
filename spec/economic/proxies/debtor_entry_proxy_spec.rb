require './spec/spec_helper'

describe Economic::DebtorEntryProxy do
  let(:session) { make_session }
  subject { Economic::DebtorEntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe "#find_by_invoice_number" do
    it 'should be able to find multiple debtor entries' do
      mock_request("DebtorEntry_FindByInvoiceNumber", {'from' => '123', 'to' => '456'}, :many)
      subject.find_by_invoice_number('123', '456').should == [1, 2]
    end

    it 'should be able to find debtor entries with one invoice id' do
      mock_request("DebtorEntry_FindByInvoiceNumber", {'from' => '123', 'to' => '123'}, :many)
      subject.find_by_invoice_number('123').should == [1, 2]
    end

    it 'should handle a single serial number in the response' do
      stub_request("DebtorEntry_FindByInvoiceNumber", nil, :single)
      subject.find_by_invoice_number('123').should == [1]
    end
  end

  describe "#match" do
    it 'should match two debtor entries by serial numbers' do
      stub_request(
        "DebtorEntry_MatchEntries",
        {:entries => [
          { :debtor_entry_handle => { :serial_number => 1 } },
          { :debtor_entry_handle => { :serial_number => 2 } }
        ]},
        :success
      )
      subject.match(1, 2)
    end
  end

  describe "#entity_class" do
    it "should return Economic::DebtorEntry" do
      Economic::DebtorEntryProxy.entity_class.should == Economic::DebtorEntry
    end
  end
end
