require "./spec/spec_helper"

describe Economic::DebtorEntry do
  let(:session) { make_session }
  subject { Economic::DebtorEntry.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::DebtorEntry.ancestors).to include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a DebtorEntryProxy" do
      expect(subject.proxy).to be_instance_of(Economic::DebtorEntryProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
