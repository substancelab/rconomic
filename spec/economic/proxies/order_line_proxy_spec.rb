# frozen_string_literal: true

require "./spec/spec_helper"

describe Economic::OrderLineProxy do
  let(:session) { make_session }
  subject { Economic::OrderLineProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new Order" do
      expect(subject.build).to be_instance_of(Economic::OrderLine)
    end

    it "assigns the session to the Order" do
      expect(subject.build.session).to equal(session)
    end

    it "should not build a partial Order" do
      expect(subject.build).to_not be_partial
    end
  end

  describe ".find" do
    it "gets order data from API" do
      mock_request("OrderLine_GetData", {"entityHandle" => {"Id" => 42}}, :success)
      subject.find(42)
    end

    it "returns Order object" do
      stub_request("OrderLine_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::OrderLine)
    end
  end
end
