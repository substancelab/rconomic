require './spec/spec_helper'

describe Economic::Creditor do
  let(:session) { make_session }
  subject { Economic::Creditor.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::Creditor.ancestors.should include(Economic::Entity)
  end

  describe "class methods" do
    subject { Economic::Creditor }

    describe ".proxy" do
      it "should return CreditorProxy" do
        subject.proxy.should == Economic::CreditorProxy
      end
    end

    describe ".key" do
      it "should == :creditor" do
        Economic::Creditor.key.should == :creditor
      end
    end
  end

  describe ".contacts" do
    it "returns a CreditorContactProxy" do
      subject.contacts.should be_instance_of(Economic::CreditorContactProxy)
    end

    it "memoizes the proxy" do
      subject.contacts.should === subject.contacts
    end

    it "should store the session" do
      subject.session.should_not be_nil
      subject.contacts.session.should == subject.session
    end
  end

  describe ".proxy" do
    it "should return a CreditorProxy" do
      subject.proxy.should be_instance_of(Economic::CreditorProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

end
