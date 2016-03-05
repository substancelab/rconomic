require "./spec/spec_helper"

describe Economic::InvoiceProxy do
  let(:session) { make_session }
  subject { Economic::InvoiceProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new Invoice" do
      expect(subject.build).to be_instance_of(Economic::Invoice)
    end

    it "assigns the session to the Invoice" do
      expect(subject.build.session).to equal(session)
    end

    it "should not build a partial Invoice" do
      expect(subject.build).to_not be_partial
    end
  end

  describe ".find" do
    it "gets invoice data from API" do
      mock_request(
        "Invoice_GetData",
        {"entityHandle" => {"Number" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns Invoice object" do
      stub_request("Invoice_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::Invoice)
    end
  end

  describe ".find_by_date_interval" do
    let(:from) { Time.now - 60 }
    let(:unto) { Time.now }

    it "should be able to return a single current invoice" do
      mock_request(
        "Invoice_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :single
      )
      mock_request("Invoice_GetDataArray", :any, :single)
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(1)
      expect(results.first).to be_instance_of(Economic::Invoice)
    end

    it "should be able to return multiple invoices" do
      mock_request(
        "Invoice_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :many
      )
      mock_request("Invoice_GetDataArray", :any, :multiple)
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(2)
      expect(results.first).to be_instance_of(Economic::Invoice)
    end

    it "should be able to return nothing" do
      mock_request(
        "Invoice_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :none
      )
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(0)
    end
  end
end
