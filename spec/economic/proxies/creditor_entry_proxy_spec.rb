require './spec/spec_helper'

describe Economic::CreditorEntryProxy do
  let(:session) { make_session }
  subject { Economic::CreditorEntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe "#find_by_invoice_number" do
    it 'should be able to find multiple creditor entries' do
      mock_request("CreditorEntry_FindByInvoiceNumber", {'invoiceNumber' => '123'}, :many)
      subject.find_by_invoice_number('123').should == [1, 2]
    end

    it 'should handle a single serial number in the response' do
      stub_request("CreditorEntry_FindByInvoiceNumber", nil, :single)
      subject.find_by_invoice_number('123').should == [1]
    end
  end

  describe "#find" do
    it 'should get a creditor entry by serial number' do
      mock_request("CreditorEntry_GetData", {'entityHandle' => { 'SerialNumber' => '123' }}, :success)
      subject.find('123').should be_instance_of(Economic::CreditorEntry)
    end
  end

  describe "#match" do
    it 'should match two creditor entries by serial numbers' do
      savon.stubs("CreditorEntry_MatchEntries").with(
        :entries => [
          { :creditor_entry_handle => { :serial_number => 1 } },
          { :credior_entry_handle => { :serial_number => 2 } }
        ]
      ).returns(:success)
      subject.match(1, 2)
    end
  end

  describe "#entity_class" do
    it "should return Economic::CreditorEntry" do
      Economic::CreditorEntryProxy.entity_class.should == Economic::CreditorEntry
    end
  end
end
