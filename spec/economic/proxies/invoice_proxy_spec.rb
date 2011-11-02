require './spec/spec_helper'

describe Economic::InvoiceProxy do

  let(:session) { make_session }
  subject { Economic::InvoiceProxy.new(session) }

  describe ".new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new Invoice" do
      subject.build.should be_instance_of(Economic::Invoice)
    end

    it "assigns the session to the Invoice" do
      subject.build.session.should === session
    end

    it "should not build a partial Invoice" do
      subject.build.should_not be_partial
    end
  end

  describe ".find" do
    before :each do
      savon.stubs('Invoice_GetData').returns(:success)
    end

    it "gets invoice data from API" do
      savon.expects('Invoice_GetData').with('entityHandle' => {'Number' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns Invoice object" do
      subject.find(42).should be_instance_of(Economic::Invoice)
    end
  end  

  describe ".find_by_date_interval" do

    it "should be able to return a single current invoice" do
      from = Time.now - 60
      unto = Time.now
      savon.expects('Invoice_FindByDateInterval').with('first' => from.iso8601, 'last' => unto.iso8601).returns(:single)
      savon.expects('Invoice_GetData').returns(:success)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 1
      results.first.should be_instance_of(Economic::Invoice)
    end

    it "should be able to return multiple invoices" do
      from = Time.now - 60
      unto = Time.now
      savon.expects('Invoice_FindByDateInterval').with('first' => from.iso8601, 'last' => unto.iso8601).returns(:many)
      savon.expects('Invoice_GetData').returns(:success)
      savon.expects('Invoice_GetData').returns(:success)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 2
      results.first.should be_instance_of(Economic::Invoice)
    end

    it "should be able to return nothing" do
      from = Time.now - 60
      unto = Time.now
      savon.expects('Invoice_FindByDateInterval').with('first' => from.iso8601, 'last' => unto.iso8601).returns(:none)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 0
    end

  end
end
