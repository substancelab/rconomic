require './spec/spec_helper'

describe Economic::CashBookEntry do
  let(:session) { make_session }
  subject { Economic::CashBookEntry.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::CashBookEntry.ancestors.should include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a CashBookEntryProxy" do
      subject.proxy.should be_instance_of(Economic::CashBookEntryProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end
end
