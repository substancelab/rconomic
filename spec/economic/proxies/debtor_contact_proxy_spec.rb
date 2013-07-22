require './spec/spec_helper'

describe Economic::DebtorContactProxy do
  let(:session) { make_session }
  subject { Economic::DebtorContactProxy.new(session) }

  describe ".new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new DebtorContact" do
      subject.build.should be_instance_of(Economic::DebtorContact)
    end

    it "assigns the session to the DebtorContact" do
      subject.build.session.should === session
    end

    it "should not build a partial DebtorContact" do
      subject.build.should_not be_partial
    end

    context "when owner is a Debtor" do
      let(:debtor) { make_debtor(:session => session) }
      subject { debtor.contacts }

      it "should use the Debtors session" do
        subject.build.session.should == debtor.session
      end

      it "should initialize with values from Debtor" do
        contact = subject.build
        contact.debtor_handle.should == debtor.handle
      end
    end
  end

  describe ".find" do
    before :each do
      savon.stubs('DebtorContact_GetData').returns(:success)
    end

    it "gets contact data from API" do
      savon.expects('DebtorContact_GetData').with('entityHandle' => {'Id' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns DebtorContact object" do
      subject.find(42).should be_instance_of(Economic::DebtorContact)
    end
  end

  describe "#find_by_name" do
    it "uses the FindByName command" do
      Economic::Proxies::Actions::DebtorContactProxy::FindByName.expects(:new).
        with(subject, "Bob").
        returns(lambda { "Result" })
      subject.find_by_name("Bob").should == "Result"
    end
  end
end
