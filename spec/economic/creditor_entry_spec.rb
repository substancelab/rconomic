require "./spec/spec_helper"

describe Economic::CreditorEntry do
  let(:session) { make_session }
  subject { Economic::CreditorEntry.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(subject).to be_a(Economic::Entity)
  end

  describe "#proxy" do
    it "should return a CreditorEntryProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CreditorEntryProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
