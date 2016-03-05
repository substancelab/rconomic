require "./spec/spec_helper"

describe Economic::CurrentInvoiceLineProxy do
  let(:session) { make_session }
  let(:invoice) { make_current_invoice(:session => session) }
  subject { Economic::CurrentInvoiceLineProxy.new(invoice) }

  describe "new" do
    it "stores owner" do
      expect(subject.owner).to eq(invoice)
    end

    it "stores session" do
      expect(subject.session).to eq(invoice.session)
    end
  end

  describe ".append" do
    it "ignores duplicated lines" do
      line = Economic::CurrentInvoiceLine.new
      subject.append(line)
      subject.append(line)
      expect(subject.size).to eq(1)
    end
  end

  describe ".build" do
    it "instantiates a new CurrentInvoiceLine" do
      expect(subject.build).to be_instance_of(Economic::CurrentInvoiceLine)
    end

    it "assigns the session to the CurrentInvoiceLine" do
      expect(subject.build.session).to eq(session)
    end

    it "should not build a partial CurrentInvoiceLine" do
      expect(subject.build).to_not be_partial
    end

    it "adds the built line to proxy items" do
      line = subject.build(:number => 5)
      expect(subject.first).to eq(line)
    end

    context "when owner is a CurrentInvoice" do
      subject { invoice.lines }

      it "should use the Debtors session" do
        expect(subject.build.session).to eq(invoice.session)
      end

      it "should initialize with values from CurrentInvoice" do
        invoice_line = subject.build
        expect(invoice_line.invoice_handle).to eq(invoice.handle)
      end
    end
  end

  describe ".find" do
    it "gets invoice_line data from API" do
      mock_request(
        "CurrentInvoiceLine_GetData",
        {"entityHandle" => {"Number" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns CurrentInvoiceLine object" do
      stub_request("CurrentInvoiceLine_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::CurrentInvoiceLine)
    end
  end

  describe "enumerable" do
    it "can be empty" do
      expect(subject).to be_empty
    end

    it "can be appended to" do
      line = Economic::CurrentInvoiceLine.new(:number => 5)
      subject << line
      expect(subject.last).to eq(line)
    end

    it "can be iterated over" do
      line = Economic::CurrentInvoiceLine.new
      subject << line
      expect(subject.all? { |l|
        l.is_a?(Economic::CurrentInvoiceLine)
      }).to be_truthy
    end
  end
end
