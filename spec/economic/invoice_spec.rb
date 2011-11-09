require './spec/spec_helper'

describe Economic::CurrentInvoice do
  let(:session) { make_session }
  subject { (i = Economic::Invoice.new( :number => 512 )).tap { i.session = session } }

  it "inherits from Economic::Entity" do
    Economic::Invoice.ancestors.should include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a InvoiceProxy" do
      subject.proxy.should be_instance_of(Economic::InvoiceProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

  describe ".key" do
    it "should == :invoice" do
      Economic::Invoice.key.should == :invoice
    end
  end

  describe "#pdf" do
    before :each do
      savon.stubs('Invoice_GetPdf').returns(:success)
    end

    it "gets PDF data from API" do
      savon.expects('Invoice_GetPdf').with('invoiceHandle' => {'Number' => 512}).returns(:success)
      subject.pdf
    end

    it "decodes the base64Binary encoded data" do
      subject.pdf.should == 'This is not really PDF data'
    end
  end

  describe "#attention" do
    let(:contact) { (c = Economic::DebtorContact.new).tap { c.session = session }}

    it "should be set- and gettable" do
      subject.attention = contact
      subject.attention_handle.should == contact.handle
      subject.attention.should == contact
    end
  end

  describe "#debtor" do
    let(:debtor) { (c = Economic::Debtor.new).tap { c.session = session }}

    it "should be set- and gettable" do
      subject.debtor = debtor
      subject.debtor_handle.should == debtor.handle
      subject.debtor.should == debtor
    end
  end
end
