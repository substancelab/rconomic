require 'spec/spec_helper'

describe Economic::Debtor do
  let(:session) { stub_session }
  subject { Economic::Debtor.new }

  it "inherits from Economic::Entity" do
    Economic::Debtor.ancestors.should include(Economic::Entity)
  end
end
