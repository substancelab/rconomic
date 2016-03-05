require "./spec/spec_helper"

describe Economic::EntryProxy do
  let(:session) { make_session }
  subject { Economic::EntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe "#find_by_date_interval" do
    it "should be able to find multiple entries" do
      from_date = Date.new
      to_date = Date.new
      mock_request(
        "Entry_FindByDateInterval",
        {"fromDate" => from_date, "toDate" => to_date},
        :many
      )
      expect(subject.find_by_date_interval(from_date, to_date)).to eq([1, 2])
    end

    it "should handle a single serial number in the response" do
      stub_request("Entry_FindByDateInterval", nil, :single)
      expect(subject.find_by_date_interval(Date.new, Date.new)).to eq([1])
    end

    it "should handle an empty response" do
      stub_request("Entry_FindByDateInterval", nil, :none)
      expect(subject.find_by_date_interval(Date.new, Date.new)).to eq([])
    end
  end

  describe "#find_by_serial_number_interval" do
    it "should be able to find multiple entries" do
      mock_request(
        "Entry_FindBySerialNumberInterval",
        {"minNumber" => 123, "maxNumber" => 456},
        :many
      )
      expect(subject.find_by_serial_number_interval(123, 456)).to eq([1, 2])
    end

    it "should handle a single serial number in the response" do
      stub_request("Entry_FindBySerialNumberInterval", nil, :single)
      expect(subject.find_by_serial_number_interval(123, 456)).to eq([1])
    end

    it "should handle an empty response" do
      stub_request("Entry_FindBySerialNumberInterval", nil, :none)
      expect(subject.find_by_serial_number_interval(123, 456)).to eq([])
    end
  end

  describe "#get_last_used_serial_number" do
    it "returns the number" do
      mock_request("Entry_GetLastUsedSerialNumber", nil, :success)
      expect(subject.get_last_used_serial_number).to eq(123)
    end
  end

  describe "#find" do
    it "should get a entry by serial number" do
      mock_request(
        "Entry_GetData",
        {"entityHandle" => {"SerialNumber" => "123"}},
        :success
      )
      expect(subject.find("123")).to be_instance_of(Economic::Entry)
    end
  end

  describe "#entity_class" do
    it "should return Economic::Entry" do
      expect(Economic::EntryProxy.entity_class).to eq(Economic::Entry)
    end
  end
end
