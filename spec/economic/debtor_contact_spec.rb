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
      before :each do
        subject.debtor_handle = {:number => 42}
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

end
