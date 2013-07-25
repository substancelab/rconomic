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
      savon.expects('CurrentInvoice_GetData').with('entityHandle' => {'Id' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns CurrentInvoice object" do
      subject.find(42).should be_instance_of(Economic::CurrentInvoice)
    end
  end

  describe ".find_by_date_interval" do
    let(:from) { Time.now - 60 }
    let(:unto) { Time.now }

    it "should be able to return a single current invoice" do
      savon.expects('CurrentInvoice_FindByDateInterval').with('first' => from.iso8601, 'last' => unto.iso8601).returns(:single)
      savon.expects('CurrentInvoice_GetDataArray').returns(:single)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 1
      results.first.should be_instance_of(Economic::CurrentInvoice)
    end

    it "should be able to return multiple invoices" do
      savon.expects('CurrentInvoice_FindByDateInterval').with('first' => from.iso8601, 'last' => unto.iso8601).returns(:many)
      savon.expects('CurrentInvoice_GetDataArray').returns(:multiple)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 2
      results.first.should be_instance_of(Economic::CurrentInvoice)
    end

    it "should be able to return nothing" do
      savon.expects('CurrentInvoice_FindByDateInterval').with('first' => from.iso8601, 'last' => unto.iso8601).returns(:none)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 0
    end

  end
  
  describe ".all" do

    it "returns an empty array when there are no current invoices" do
      savon.expects('CurrentInvoice_GetAll').returns(:none)
      subject.all.size.should == 0
    end

    it "finds and adds a single current invoice" do
      savon.expects('CurrentInvoice_GetAll').returns(:single)
      savon.expects('CurrentInvoice_GetData').with('entityHandle' => {'Id' => 1}).returns(:success)

      current_invoices = subject.all
      current_invoices.should be_instance_of(Economic::CurrentInvoiceProxy)

      current_invoices.size.should == 1
      current_invoices.first.should be_instance_of(Economic::CurrentInvoice)
    end

    it "adds multiple current invoices" do
      savon.expects('CurrentInvoice_GetAll').returns(:multiple)
      savon.expects('CurrentInvoice_GetDataArray').returns(:multiple)

      current_invoices = subject.all
      current_invoices.size.should == 2
      current_invoices.first.should be_instance_of(Economic::CurrentInvoice)
      current_invoices.last.should be_instance_of(Economic::CurrentInvoice)
    end

  end
end
