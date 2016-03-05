require "./spec/spec_helper"

describe Economic::Entry do
  let(:session) { make_session }
  subject { Economic::Entry.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::Entry.ancestors).to include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a EntryProxy" do
      expect(subject.proxy).to be_instance_of(Economic::EntryProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
