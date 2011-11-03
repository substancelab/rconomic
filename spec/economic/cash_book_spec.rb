require './spec/spec_helper'

describe Economic::CashBook do
  let(:session) { make_session }

  it "inherits from Economic::Entity" do
    Economic::Debtor.superclass.should == Economic::Entity
  end

  describe "class methods" do
    subject { Economic::CashBook }

    describe ".proxy" do
      it "should return CashBookProxy" do
        subject.proxy.should == Economic::CashBookProxy
      end
    end
  end
end
