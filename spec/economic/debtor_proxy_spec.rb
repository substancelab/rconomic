require 'spec/spec_helper'

describe Economic::DebtorProxy do
  let(:session) { Economic::Session.new(123456, 'api', 'passw0rd') }
  subject { Economic::DebtorProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe "find" do
    before :each do
      savon.stubs('Debtor_GetData').returns(:success)
    end

    it "gets debtor data from API" do
      savon.expects('Debtor_GetData').with('entityHandle' => {'Number' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns Debtor object" do
      subject.find(42).should be_instance_of(Economic::Debtor)
    end
  end

  describe "find_by_ci_number" do
    it "uses FindByCINumber on API" do
      savon.expects('Debtor_FindByCINumber').with('ciNumber' => '12345678').returns(:many)
      subject.find_by_ci_number('12345678')
    end

    context "when many debtors exist" do
      before :each do
        savon.stubs('Debtor_FindByCINumber').returns(:many)
      end

      let(:results) { subject.find_by_ci_number('12345678') }

      it "returns a Debtor object for each result" do
        results.size.should == 2
        results.all? { |result| result.should be_instance_of(Economic::Debtor) }
      end

      it "returns partial Debtor objects" do
        results.all? { |result| result.should be_partial }
      end

      it "returns persisted Debtor objects" do
        results.all? { |result| result.should be_persisted }
      end
    end
  end


  describe "next_available_number" do
    it "gets the next available debtor number from API" do
      savon.expects('Debtor_GetNextAvailableNumber').returns(:success)
      subject.next_available_number.should == '105'
    end
  end
end