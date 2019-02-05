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

  describe ".find_by_order" do
    it "returns orderline for order" do
      stub_request("OrderLine_FindByOrderList", nil, :single)
      mock_request("OrderLine_GetDataArray", :any, :single)
      results = subject.find_by_order(31)
      expect(results.size).to eq(1)
      expect(results.first).to be_instance_of(Economic::OrderLine)
    end

    it "returns orderlines for order" do
      stub_request("OrderLine_FindByOrderList", nil, :multiple)
      mock_request("OrderLine_GetDataArray", :any, :multiple)
      results = subject.find_by_order(31)
      expect(results.size).to eq(2)
      expect(results.first).to be_instance_of(Economic::OrderLine)
    end

    it "returns empty array when orderlines for an order" do
      stub_request("OrderLine_FindByOrderList", nil, :none)
      expect(subject.find_by_order(31)).to eq([])
    end
  end
end
