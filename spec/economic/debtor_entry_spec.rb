require './spec/spec_helper'

describe Economic::DebtorEntry do
  let(:session) { make_session }
  subject { Economic::DebtorEntry.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::DebtorEntry.ancestors.should include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a DebtorEntryProxy" do
      subject.proxy.should be_instance_of(Economic::DebtorEntryProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end
end
