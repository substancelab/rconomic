require './spec/spec_helper'

describe Economic::CurrentInvoiceLine do
  let(:session) { make_session }
  subject { (l = Economic::CurrentInvoiceLine.new).tap { l.session = session } }

  it "inherits from Economic::Entity" do
    Economic::CurrentInvoiceLine.ancestors.should include(Economic::Entity)
  end

  describe "equality" do
    it "should not be equal when both are newly created" do
      line1 = Economic::CurrentInvoiceLine.new({})
      line2 = Economic::CurrentInvoiceLine.new({})

      line1.should_not == line2
    end

    it "should not be equal when numbers are different" do
      line1 = Economic::CurrentInvoiceLine.new({:number => 1})
      line2 = Economic::CurrentInvoiceLine.new({:number => 2})

      line1.should_not == line2
    end
  end

  describe "#invoice=" do
    it "changes the invoice_handle" do
      invoice = Economic::CurrentInvoice.new(:id => 42)

      subject.invoice = invoice

      subject.invoice.should == invoice
      subject.invoice_handle.should == invoice.handle
    end
  end

  describe ".proxy" do
    it "should return a CurrentInvoiceLineProxy" do
      subject.proxy.should be_instance_of(Economic::CurrentInvoiceLineProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

end
