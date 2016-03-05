require "./spec/spec_helper"

describe Economic::CurrentInvoiceProxy do
  let(:session) { make_session }
  subject { Economic::CurrentInvoiceProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new CurrentInvoice" do
      expect(subject.build).to be_instance_of(Economic::CurrentInvoice)
    end

    it "assigns the session to the CurrentInvoice" do
      expect(subject.build.session).to equal(session)
    end

    it "should not build a partial CurrentInvoice" do
      expect(subject.build).to_not be_partial
    end

    context "when owner is a Debtor" do
      let(:debtor) { make_debtor(:session => session) }
      subject { debtor.current_invoices }

      it "should use the Debtors session" do
        expect(subject.build.session).to eq(debtor.session)
      end

      it "should initialize with values from Debtor" do
        invoice = subject.build

        expect(invoice.debtor_name).to eq(debtor.name)
        expect(invoice.debtor_address).to eq(debtor.address)
        expect(invoice.debtor_postal_code).to eq(debtor.postal_code)
        expect(invoice.debtor_city).to eq(debtor.city)

        expect(invoice.debtor_handle).to eq(debtor.handle)
        expect(invoice.term_of_payment_handle).to eq(
          debtor.term_of_payment_handle
        )
        expect(invoice.layout_handle).to eq(debtor.layout_handle)
        expect(invoice.currency_handle).to eq(debtor.currency_handle)
      end
    end
  end

  describe ".find" do
    it "gets invoice data from API" do
      mock_request(
        "CurrentInvoice_GetData",
        {"entityHandle" => {"Id" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns CurrentInvoice object" do
      stub_request("CurrentInvoice_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::CurrentInvoice)
    end
  end

  describe ".find_by_date_interval" do
    let(:from) { Time.now - 60 }
    let(:unto) { Time.now }

    it "should be able to return a single current invoice" do
      mock_request(
        "CurrentInvoice_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :single
      )
      stub_request("CurrentInvoice_GetDataArray", nil, :single)
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(1)
      expect(results.first).to be_instance_of(Economic::CurrentInvoice)
    end

    it "should be able to return multiple invoices" do
      mock_request(
        "CurrentInvoice_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :many
      )
      stub_request("CurrentInvoice_GetDataArray", nil, :multiple)
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(2)
      expect(results.first).to be_instance_of(Economic::CurrentInvoice)
    end

    it "should be able to return nothing" do
      mock_request(
        "CurrentInvoice_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :none
      )
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(0)
    end
  end

  describe ".all" do
    it "returns an empty array when there are no current invoices" do
      stub_request("CurrentInvoice_GetAll", nil, :none)
      expect(subject.all.size).to eq(0)
    end

    it "finds and adds a single current invoice" do
      stub_request("CurrentInvoice_GetAll", nil, :single)
      mock_request(
        "CurrentInvoice_GetData",
        {"entityHandle" => {"Id" => 1}},
        :success
      )

      current_invoices = subject.all
      expect(current_invoices).to be_instance_of(Economic::CurrentInvoiceProxy)

      expect(current_invoices.size).to eq(1)
      expect(current_invoices.first).to be_instance_of(Economic::CurrentInvoice)
    end

    it "adds multiple current invoices" do
      stub_request("CurrentInvoice_GetAll", nil, :multiple)
      stub_request("CurrentInvoice_GetDataArray", nil, :multiple)

      current_invoices = subject.all
      expect(current_invoices.size).to eq(2)
      expect(current_invoices.first).to be_instance_of(Economic::CurrentInvoice)
      expect(current_invoices.last).to be_instance_of(Economic::CurrentInvoice)
    end
  end
end
