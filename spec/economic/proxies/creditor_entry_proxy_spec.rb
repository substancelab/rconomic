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
      savon.expects("CreditorEntry_FindByInvoiceNumber").with('invoiceNumber' => '123').returns(:many)
      subject.find_by_invoice_number('123').should == [1, 2]
    end

    it 'should handle a single serial number in the response' do
      savon.stubs("CreditorEntry_FindByInvoiceNumber").returns(:single)
      subject.find_by_invoice_number('123').should == [1]
    end
  end

  describe "#find" do
    it 'should get a creditor entry by serial number' do
      savon.expects("CreditorEntry_GetData").with('entityHandle' => { 'SerialNumber' => '123' }).returns(:success)
      subject.find('123').should be_instance_of(Economic::CreditorEntry)
    end
  end

  describe "#entity_class" do
    it "should return Economic::CreditorEntry" do
      Economic::CreditorEntryProxy.entity_class.should == Economic::CreditorEntry
    end
  end
end
