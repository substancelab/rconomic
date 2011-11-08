require './spec/spec_helper'

describe Economic::Invoice do
  let(:session) { make_session }
  subject { Economic::Invoice.new(:session => session, :number => 512) }

  it "inherits from Economic::Entity" do
    Economic::Invoice.ancestors.should include(Economic::Entity)
  end

  describe '#remainder' do
    it 'should get the remainder' do
      savon.expects('Invoice_GetRemainder').with("invoiceHandle" => { "Number" => 512 }).returns(:success)
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

end
