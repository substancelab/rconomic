require './spec/spec_helper'

describe Economic::Debtor do
  let(:session) { stub_session }
  subject { Economic::Debtor.new }

  it "inherits from Economic::Entity" do
    Economic::Debtor.ancestors.should include(Economic::Entity)
  end

  context "when saving" do
    context "when debtor is new" do
      subject { Economic::Debtor.new(:session => session) }

      context "when debtor_group_handle is nil" do
        before :each do
          subject.debtor_group_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          session.expects(:request)
          subject.save
        end
      end
    end
  end
end
