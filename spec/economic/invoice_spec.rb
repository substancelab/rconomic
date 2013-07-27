require './spec/spec_helper'

describe Economic::Invoice do
  let(:session) { make_session }
  subject { Economic::Invoice.new(:session => session, :number => 512) }

  it "inherits from Economic::Entity" do
    Economic::Invoice.ancestors.should include(Economic::Entity)
  end

  describe '#remainder' do
    it 'should get the remainder' do
      mock_request('Invoice_GetRemainder', {"invoiceHandle" => { "Number" => 512 }}, :success)
      subject.remainder.should == "512.32"
    end
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
    it "gets PDF data from API" do
      mock_request('Invoice_GetPdf', {'invoiceHandle' => {'Number' => 512}}, :success)
      subject.pdf
    end

    it "decodes the base64Binary encoded data" do
      stub_request('Invoice_GetPdf', nil, :success)
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
