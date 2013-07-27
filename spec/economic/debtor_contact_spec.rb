require './spec/spec_helper'

describe Economic::DebtorContact do
  let(:session) { make_session }
  subject { Economic::DebtorContact.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::DebtorContact.ancestors.should include(Economic::Entity)
  end

  context "when saving" do
    context "when debtor contact is new" do
      subject { Economic::DebtorContact.new(:session => session) }

      context "when debtor_handle is nil" do
        before :each do
          subject.debtor_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          session.expects(:request)
          subject.save
        end
      end
    end
  end

  describe ".debtor" do
    context "when debtor_handle is not set" do
      it "returns nil" do
        subject.debtor.should be_nil
      end
    end

    context "when debtor_handle is set" do
      let(:handle) { Economic::DebtorContact::Handle.new({:number => 42}) }

      before :each do
        subject.debtor_handle = handle
      end

      it "returns a Debtor" do
        session.debtors.expects(:find).with(42).returns(Economic::Debtor.new)
        subject.debtor.should be_instance_of(Economic::Debtor)
      end

      it "only looks up the debtor the first time" do
        session.debtors.expects(:find).with(42).returns(Economic::Debtor.new)
        subject.debtor.should === subject.debtor
      end
    end
  end

  describe ".debtor=" do
    let(:debtor) { make_debtor }
    it "should set debtor_handle" do
      subject.debtor = debtor
      subject.debtor_handle.should == debtor.handle
    end
  end

  describe ".debtor_handle=" do
    let(:debtor) { make_debtor }
    let(:handle) { debtor.handle }

    it "should set debtor_handle" do
      subject.debtor_handle = handle
      subject.debtor_handle.should == handle
    end

    context "when debtor handle is for a different Debtor" do
      before :each do
        subject.debtor = debtor
      end

      it "should clear cached debtor and fetch the new debtor from API" do
        stub_request('Debtor_GetData', nil, :success)
        subject.debtor_handle = Economic::Debtor::Handle.new({:number => 1234})
        subject.debtor.should be_instance_of(Economic::Debtor)
      end
    end

    context "when debtor handle is for the current Debtor" do
      before :each do
        subject.debtor = debtor
      end

      it "should not clear cached debtor nor fetch the debtor from API" do
        savon.stubs('Debtor_GetData').never
        subject.debtor_handle = handle
        subject.debtor.should be_instance_of(Economic::Debtor)
      end
    end
  end

  describe ".proxy" do
    it "should return a DebtorContactProxy" do
      subject.proxy.should be_instance_of(Economic::DebtorContactProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

end
