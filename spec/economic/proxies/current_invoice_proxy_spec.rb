require './spec/spec_helper'

describe Economic::CurrentInvoiceProxy do
  let(:session) { make_session }
  subject { Economic::CurrentInvoiceProxy.new(session) }

  describe ".new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new CurrentInvoice" do
      subject.build.should be_instance_of(Economic::CurrentInvoice)
    end

    it "assigns the session to the CurrentInvoice" do
      subject.build.session.should === session
    end

    it "should not build a partial CurrentInvoice" do
      subject.build.should_not be_partial
    end

    context "when owner is a Debtor" do
      let(:debtor) { make_debtor(:session => session) }
      subject { debtor.current_invoices }

      it "should use the Debtors session" do
        subject.build.session.should == debtor.session
      end

      it "should initialize with values from Debtor" do
        invoice = subject.build

        invoice.debtor_name.should == debtor.name
        invoice.debtor_address.should == debtor.address
        invoice.debtor_postal_code.should == debtor.postal_code
        invoice.debtor_city.should == debtor.city

        invoice.debtor_handle.should == debtor.handle
        invoice.term_of_payment_handle.should == debtor.term_of_payment_handle
        invoice.layout_handle.should == debtor.layout_handle
        invoice.currency_handle.should == debtor.currency_handle
      end
    end
  end

  describe ".find" do
    before :each do
      savon.stubs('CurrentInvoice_GetData').returns(:success)
    end

    it "gets invoice data from API" do
      savon.expects('CurrentInvoice_GetData').with('entityHandle' => {'Number' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns CurrentInvoice object" do
      subject.find(42).should be_instance_of(Economic::CurrentInvoice)
    end
  end
end