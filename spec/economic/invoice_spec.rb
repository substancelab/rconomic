require "./spec/spec_helper"

describe Economic::Invoice do
  let(:session) { make_session }
  subject { Economic::Invoice.new(:session => session, :number => 512) }

  it "inherits from Economic::Entity" do
    expect(Economic::Invoice.ancestors).to include(Economic::Entity)
  end

  describe '#remainder' do
    it "should get the remainder" do
      mock_request("Invoice_GetRemainder", {"invoiceHandle" => {"Number" => 512}}, :success)
      expect(subject.remainder).to eq(512.32)
    end
  end

  describe ".proxy" do
    it "should return a InvoiceProxy" do
      expect(subject.proxy).to be_instance_of(Economic::InvoiceProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe ".key" do
    it "should == :invoice" do
      expect(Economic::Invoice.key).to eq(:invoice)
    end
  end

  describe "#pdf" do
    it "gets PDF data from API" do
      mock_request("Invoice_GetPdf", {"invoiceHandle" => {"Number" => 512}}, :success)
      subject.pdf
    end

    it "decodes the base64Binary encoded data" do
      stub_request("Invoice_GetPdf", nil, :success)
      expect(subject.pdf).to eq("This is not really PDF data")
    end
  end

  describe "#attention" do
    let(:contact) {
      Economic::DebtorContact.new.tap do |c|
        c.session = session
        c.id = 5
      end
    }

    it "should be set- and gettable" do
      subject.attention = contact
      expect(subject.attention).to eq(contact)
    end

    it "updates the handle" do
      handle = Economic::Entity::Handle.new(:number => 42)
      contact.handle = handle
      subject.attention = contact
      expect(subject.attention_handle).to eq(handle)
    end
  end

  describe "#debtor" do
    let(:debtor) {
      Economic::Debtor.new.tap do |c|
        c.session = session
        c.number = 5
      end
    }

    it "should be set- and gettable" do
      subject.debtor = debtor
      expect(subject.debtor).to eq(debtor)
    end

    it "updates the handle" do
      handle = Economic::Entity::Handle.new(:number => 42)
      debtor.handle = handle
      subject.debtor = debtor
      expect(subject.debtor_handle).to eq(handle)
    end
  end

  describe "#days_past_due" do
    it "after date has passed" do
      subject.due_date = (Date.today - 3).to_datetime
      expect(subject.days_past_due).to eq(3)
    end

    it "before date has passed" do
      subject.due_date = (Date.today + 3).to_datetime
      expect(subject.days_past_due).to eq(0)
    end
  end

  describe "#past_due?" do
    it "when due date has passed and the invoiced hasn't been paid" do
      subject.due_date = (Date.today - 3).to_datetime
      subject.instance_variable_set "@remainder", 1

      expect(subject.past_due?).to eq(true)
    end

    it "when due date has passed and the invoice has been paid" do
      subject.due_date = (Date.today - 3).to_datetime
      subject.instance_variable_set "@remainder", 0

      expect(subject.past_due?).to eq(false)
    end

    it "before due date has passed and the invoiced hasn't been paid" do
      subject.due_date = (Date.today + 3).to_datetime
      subject.instance_variable_set "@remainder", 1

      expect(subject.past_due?).to eq(false)
    end

    it "before due date has passed and the invoice has been paid" do
      subject.due_date = (Date.today + 3).to_datetime
      subject.instance_variable_set "@remainder", 0

      expect(subject.past_due?).to eq(false)
    end
  end
end
