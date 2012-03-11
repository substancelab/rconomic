require './spec/spec_helper'

describe Economic::Entry do
  let(:session) { make_session }
  subject { Economic::Entry.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::Entry.ancestors.should include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a EntryProxy" do
      subject.proxy.should be_instance_of(Economic::EntryProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end
end
