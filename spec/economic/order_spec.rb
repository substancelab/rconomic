# frozen_string_literal: true

require "./spec/spec_helper"

describe Economic::Order do
  let(:session) { make_session }
  subject { Economic::Order.new(session: session, number: 512) }

  it "inherits from Economic::Entity" do
    expect(Economic::Order.ancestors).to include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a OrderProxy" do
      expect(subject.proxy).to be_instance_of(Economic::OrderProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe ".key" do
    it "should == :invoice" do
      expect(Economic::Order.key).to eq(:order)
    end
  end

  describe "#pdf" do
    it "gets PDF data from API" do
      mock_request("Order_GetPdf", {"orderHandle" => {"Number" => 512}}, :success)
      subject.pdf
    end

    it "decodes the base64Binary encoded data" do
      stub_request("Order_GetPdf", nil, :success)
      expect(subject.pdf).to eq("This is not really PDF data")
    end
  end

  describe "#cancel_sent_status" do
    it "updates the order" do
      mock_request("Order_CancelSentStatus", {"orderHandle" => {"Number" => 512}}, :success)
      subject.cancel_sent_status
    end

    it "decodes the base64Binary encoded data" do
      stub_request("Order_CancelSentStatus", nil, :success)
      expect(subject.cancel_sent_status).to eq({})
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
      handle = Economic::Entity::Handle.new(number: 42)
      contact.handle = handle
      subject.attention = contact
      expect(subject.attention_handle).to eq(handle)
    end
  end

  describe "#order_lines" do
    let(:proxy) { instance_double(Economic::OrderLineProxy) }

    it "calls the correct proxy" do
      expect(Economic::OrderLineProxy).to receive(:new) { proxy }
      expect(proxy).to receive(:find_by_order).with("Number" => 512) { [] }
      subject.order_lines
    end
  end

  describe "#register_as_sent" do
    it "updates the order" do
      mock_request("Order_RegisterAsSent", {"orderHandle" => {"Number" => 512}}, :success)
      subject.register_as_sent
    end

    it "decodes the base64Binary encoded data" do
      stub_request("Order_RegisterAsSent", nil, :success)
      expect(subject.register_as_sent).to eq({})
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
      handle = Economic::Entity::Handle.new(number: 42)
      debtor.handle = handle
      subject.debtor = debtor
      expect(subject.debtor_handle).to eq(handle)
    end
  end
end
