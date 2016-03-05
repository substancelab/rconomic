require "./spec/spec_helper"

describe Economic::Company do
  let(:session) { make_session }
  subject { Economic::Company.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::Company.ancestors).to include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a CompanyProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CompanyProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
