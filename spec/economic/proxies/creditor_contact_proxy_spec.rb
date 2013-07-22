require './spec/spec_helper'

describe Economic::CreditorContactProxy do
  let(:session) { make_session }
  subject { Economic::CreditorContactProxy.new(session) }

  describe ".new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new CreditorContact" do
      subject.build.should be_instance_of(Economic::CreditorContact)
    end

    it "assigns the session to the CreditorContact" do
      subject.build.session.should === session
    end

    it "should not build a partial CreditorContact" do
      subject.build.should_not be_partial
    end

    context "when owner is a Creditor" do
      let(:creditor) { make_creditor(:session => session) }
      subject { creditor.contacts }

      it "should use the Creditors session" do
        subject.build.session.should == creditor.session
      end

      it "should initialize with values from Creditor" do
        contact = subject.build
        contact.creditor_handle.should == creditor.handle
      end
    end
  end

  describe ".find" do
    before :each do
      savon.stubs('CreditorContact_GetData').returns(:success)
    end

    it "gets contact data from API" do
      savon.expects('CreditorContact_GetData').with('entityHandle' => {'Id' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns CreditorContact object" do
      subject.find(42).should be_instance_of(Economic::CreditorContact)
    end
  end

  describe "#find_by_name" do
    before :each do
      savon.stubs('CreditorContact_FindByName').returns(:multiple)
    end

    it "gets contact data from the API" do
      savon.expects('CreditorContact_FindByName').with('name' => 'Bob').returns(:multiple)
      subject.find_by_name("Bob")
    end

    it "returns creditor contacts" do
      subject.find_by_name("Bob").first.should be_instance_of(Economic::CreditorContact)
    end

    it "returns each contact" do
      subject.find_by_name("Bob").size.should == 2
    end

    it "returns empty when nothing is found" do
      savon.stubs('CreditorContact_FindByName').returns(:none)
      subject.find_by_name("Bob").should be_empty
    end
  end
end

