require './spec/spec_helper'

describe Economic::CreditorContact do
  let(:session) { make_session }
  subject { Economic::CreditorContact.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::CreditorContact.ancestors.should include(Economic::Entity)
  end

  context "when saving" do
    context "when creditor contact is new" do
      subject { Economic::CreditorContact.new(:session => session) }

      context "when creditor_handle is nil" do
        before :each do
          subject.creditor_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          session.expects(:request)
          subject.save
        end
      end
    end
  end

  describe ".creditor" do
    context "when creditor_handle is not set" do
      it "returns nil" do
        subject.creditor.should be_nil
      end
    end

    context "when creditor_handle is set" do
      let(:handle) { Economic::CreditorContact::Handle.new({:number => 42}) }

      before :each do
        subject.creditor_handle = handle
      end

      it "returns a Creditor" do
        session.creditors.expects(:find).with(42).returns(Economic::Creditor.new)
        subject.creditor.should be_instance_of(Economic::Creditor)
      end

      it "only looks up the creditor the first time" do
        session.creditors.expects(:find).with(42).returns(Economic::Creditor.new)
        subject.creditor.should === subject.creditor
      end
    end
  end

  describe ".creditor=" do
    let(:creditor) { make_creditor }
    it "should set creditor_handle" do
      subject.creditor = creditor
      subject.creditor_handle.should == creditor.handle
    end
  end

  describe ".creditor_handle=" do
    let(:creditor) { make_creditor }
    let(:handle) { creditor.handle }

    it "should set creditor_handle" do
      subject.creditor_handle = handle
      subject.creditor_handle.should == handle
    end

    context "when creditor handle is for a different Creditor" do
      before :each do
        subject.creditor = creditor
      end

      it "should clear cached creditor and fetch the new creditor from API" do
        stub_request('Creditor_GetData', nil, :success)
        subject.creditor_handle = Economic::Creditor::Handle.new({:number => 1234})
        subject.creditor.should be_instance_of(Economic::Creditor)
      end
    end

    context "when creditor handle is for the current Creditor" do
      before :each do
        subject.creditor = creditor
      end

      it "should not clear cached creditor nor fetch the creditor from API" do
        session.should_receive(:request).never
        subject.creditor_handle = handle
        subject.creditor.should be_instance_of(Economic::Creditor)
      end
    end
  end

  describe ".proxy" do
    it "should return a CreditorContactProxy" do
      subject.proxy.should be_instance_of(Economic::CreditorContactProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

end
