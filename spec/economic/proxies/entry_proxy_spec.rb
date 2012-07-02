require './spec/spec_helper'

describe Economic::EntryProxy do
  let(:session) { make_session }
  subject { Economic::EntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe "#find_by_date_interval" do
    it 'should be able to find multiple entries' do
      from_date = Date.new
      to_date = Date.new
      savon.expects("Entry_FindByDateInterval").
        with('fromDate' => from_date, 'toDate' => to_date).
        returns(:many)
      subject.find_by_date_interval(from_date, to_date).should == [1, 2]
    end

    it 'should handle a single serial number in the response' do
      savon.stubs("Entry_FindByDateInterval").returns(:single)
      subject.find_by_date_interval(Date.new, Date.new).should == [1]
    end

    it 'should handle an empty response' do
      savon.stubs("Entry_FindByDateInterval").returns(:none)
      subject.find_by_date_interval(Date.new, Date.new).should == []
    end
  end

  describe "#find_by_serial_number_interval" do
    it 'should be able to find multiple entries' do
      savon.expects("Entry_FindBySerialNumberInterval").
        with('minNumber' => 123, 'maxNumber' => 456).
        returns(:many)
      subject.find_by_serial_number_interval(123, 456).should == [1, 2]
    end

    it 'should handle a single serial number in the response' do
      savon.stubs("Entry_FindBySerialNumberInterval").returns(:single)
      subject.find_by_serial_number_interval(123, 456).should == [1]
    end

    it 'should handle an empty response' do
      savon.stubs("Entry_FindBySerialNumberInterval").returns(:none)
      subject.find_by_serial_number_interval(123, 456).should == []
    end
  end

  describe "#find" do
    it 'should get a entry by serial number' do
      savon.expects("Entry_GetData").with('entityHandle' => { 'SerialNumber' => '123' }).returns(:success)
      subject.find('123').should be_instance_of(Economic::Entry)
    end
  end

  describe "#entity_class" do
    it "should return Economic::Entry" do
      Economic::EntryProxy.entity_class.should == Economic::Entry
    end
  end
end

