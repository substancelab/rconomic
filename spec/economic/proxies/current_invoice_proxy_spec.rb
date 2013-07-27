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
      stub_request('CurrentInvoice_GetData', nil, :success)
    end

    it "gets invoice data from API" do
      mock_request('CurrentInvoice_GetData', {'entityHandle' => {'Id' => 42}}, :success)
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
      mock_request('CurrentInvoice_FindByDateInterval', {'first' => from.iso8601, 'last' => unto.iso8601}, :single)
      mock_request('CurrentInvoice_GetDataArray', nil, :single)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 1
      results.first.should be_instance_of(Economic::CurrentInvoice)
    end

    it "should be able to return multiple invoices" do
      mock_request('CurrentInvoice_FindByDateInterval', {'first' => from.iso8601, 'last' => unto.iso8601}, :many)
      mock_request('CurrentInvoice_GetDataArray', nil, :multiple)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 2
      results.first.should be_instance_of(Economic::CurrentInvoice)
    end

    it "should be able to return nothing" do
      mock_request('CurrentInvoice_FindByDateInterval', {'first' => from.iso8601, 'last' => unto.iso8601}, :none)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 0
    end

  end
  
  describe ".all" do

    it "returns an empty array when there are no current invoices" do
      mock_request('CurrentInvoice_GetAll', nil, :none)
      subject.all.size.should == 0
    end

    it "finds and adds a single current invoice" do
      mock_request('CurrentInvoice_GetAll', nil, :single)
      mock_request('CurrentInvoice_GetData', {'entityHandle' => {'Id' => 1}}, :success)

      current_invoices = subject.all
      current_invoices.should be_instance_of(Economic::CurrentInvoiceProxy)

      current_invoices.size.should == 1
      current_invoices.first.should be_instance_of(Economic::CurrentInvoice)
    end

    it "adds multiple current invoices" do
      mock_request('CurrentInvoice_GetAll', nil, :multiple)
      mock_request('CurrentInvoice_GetDataArray', nil, :multiple)

      current_invoices = subject.all
      current_invoices.size.should == 2
      current_invoices.first.should be_instance_of(Economic::CurrentInvoice)
      current_invoices.last.should be_instance_of(Economic::CurrentInvoice)
    end

  end
end
