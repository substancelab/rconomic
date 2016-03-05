require "./spec/spec_helper"

describe Economic::CurrentInvoiceLine do
  let(:session) { make_session }
  subject { (l = Economic::CurrentInvoiceLine.new).tap { l.session = session } }

  it "inherits from Economic::Entity" do
    expect(Economic::CurrentInvoiceLine.ancestors).to include(Economic::Entity)
  end

  describe "equality" do
    it "should not be equal when both are newly created" do
      line1 = Economic::CurrentInvoiceLine.new({})
      line2 = Economic::CurrentInvoiceLine.new({})

      expect(line1).not_to eq(line2)
    end

    it "should not be equal when numbers are different" do
      line1 = Economic::CurrentInvoiceLine.new(:number => 1)
      line2 = Economic::CurrentInvoiceLine.new(:number => 2)

      expect(line1).not_to eq(line2)
    end
  end

  describe "#invoice=" do
    it "changes the invoice_handle" do
      invoice = Economic::CurrentInvoice.new(:id => 42)

      subject.invoice = invoice

      expect(subject.invoice).to eq(invoice)
      expect(subject.invoice_handle).to eq(invoice.handle)
    end
  end

  describe ".proxy" do
    it "should return a CurrentInvoiceLineProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CurrentInvoiceLineProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe "#save" do
    context "when successful" do
      it "builds and sends data to API" do
        mock_request(
          "CurrentInvoiceLine_CreateFromData", {
            "data" => {
              "Number" => 0,
              "DeliveryDate" => nil,
              "DiscountAsPercent" => 0,
              "UnitCostPrice" => 0,
              "TotalNetAmount" => nil,
              "TotalMargin" => 0,
              "MarginAsPercent" => 0
            }
          },
          :success
        )
        subject.save
      end
    end
  end
end
