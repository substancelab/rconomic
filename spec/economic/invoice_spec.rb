require './spec/spec_helper'

describe Economic::Invoice do
  let(:session) { make_session }
  subject { Economic::Invoice.new(:session => session, :number => 512) }

  it "inherits from Economic::Entity" do
    expect(Economic::Invoice.ancestors).to include(Economic::Entity)
  end

  describe '#remainder' do
    it 'should get the remainder' do
      mock_request('Invoice_GetRemainder', {"invoiceHandle" => { "Number" => 512 }}, :success)
      expect(subject.remainder).to eq("512.32")
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
      mock_request('Invoice_GetPdf', {'invoiceHandle' => {'Number' => 512}}, :success)
      subject.pdf
    end

    it "decodes the base64Binary encoded data" do
      stub_request('Invoice_GetPdf', nil, :success)
      expect(subject.pdf).to eq('This is not really PDF data')
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
      expect(subject.attention_handle).to eq(contact.handle)
      expect(subject.attention).to eq(contact)
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
      expect(subject.debtor_handle).to eq(debtor.handle)
      expect(subject.debtor).to eq(debtor)
    end
  end
end
