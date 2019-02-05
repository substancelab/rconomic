# frozen_string_literal: true

require "./spec/spec_helper"

describe Economic::OrderLine do
  let(:session) { make_session }
  subject { Economic::OrderLine.new(:session => session, :number => 512) }

  it "inherits from Economic::Entity" do
    expect(Economic::OrderLine.ancestors).to include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a OrderProxy" do
      expect(subject.proxy).to be_instance_of(Economic::OrderLineProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
