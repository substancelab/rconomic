# frozen_string_literal: true

require "./spec/spec_helper"

describe Economic::OrderProxy do
  let(:session) { make_session }
  subject { Economic::OrderProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new Order" do
      expect(subject.build).to be_instance_of(Economic::Order)
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
      mock_request("Order_GetData", {"entityHandle" => {"Id" => 42}}, :success)
      subject.find(42)
    end

    it "returns Order object" do
      stub_request("Order_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::Order)
    end
  end

  describe ".find_by_other_reference" do
    it "returns matching order" do
      stub_request("Order_FindByOtherReference", nil, :single)
      mock_request("Order_GetDataArray", :any, :single)
      results = subject.find_by_other_reference("some reference")
      expect(results.size).to eq(1)
      expect(results.first).to be_instance_of(Economic::Order)
    end

    it "returns matching orders" do
      stub_request("Order_FindByOtherReference", nil, :multiple)
      mock_request("Order_GetDataArray", :any, :multiple)
      results = subject.find_by_other_reference("some reference")
      expect(results.size).to eq(2)
      expect(results.first).to be_instance_of(Economic::Order)
    end

    it "returns empty array when no matches" do
      stub_request("Order_FindByOtherReference", nil, :none)
      expect(subject.find_by_other_reference("some reference")).to eq([])
    end
  end

  describe ".all" do
    it "gets order data from API" do
      mock_request("Order_GetAll", nil, :success)
      mock_request("Order_GetDataArray", :any, :single)
      subject.all
    end

    it "returns Order object" do
      stub_request("Order_GetAll", nil, :success)
      mock_request("Order_GetDataArray", :any, :single)
      expect(subject.all.first).to be_instance_of(Economic::Order)
    end
  end

  describe ".current" do
    it "gets current order data from API" do
      mock_request("Order_GetAllCurrent", nil, :success)
      mock_request("Order_GetData", :any, :success)
      subject.current
    end

    it "returns Order objects" do
      stub_request("Order_GetAllCurrent", nil, :success)
      mock_request("Order_GetData", :any, :success)
      expect(subject.current.first).to be_instance_of(Economic::Order)
    end

    it "replaces the already fetched orders" do
      stub_request("Order_GetAll", nil, :success)
      stub_request("Order_GetDataArray", :any, :multiple)
      subject.all

      stub_request("Order_GetAllCurrent", nil, :success)
      mock_request("Order_GetData", :any, :success)
      newly_fetched_objects = subject.current

      expect(newly_fetched_objects.size).to eq(1)
    end
  end

  describe ".find_by_date_interval" do
    let(:from) { Time.now - 60 }
    let(:unto) { Time.now }

    it "should be able to return a single current order" do
      mock_request(
        "Order_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :single
      )
      mock_request("Order_GetDataArray", :any, :single)
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(1)
      expect(results.first).to be_instance_of(Economic::Order)
    end

    it "should be able to return multiple orders" do
      mock_request(
        "Order_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :many
      )
      mock_request("Order_GetDataArray", :any, :multiple)
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(2)
      expect(results.first).to be_instance_of(Economic::Order)
    end

    it "should be able to return nothing" do
      mock_request(
        "Order_FindByDateInterval",
        {"first" => from.iso8601, "last" => unto.iso8601},
        :none
      )
      results = subject.find_by_date_interval(from, unto)
      expect(results.size).to eq(0)
    end
  end
end
