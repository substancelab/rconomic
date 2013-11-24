require './spec/spec_helper'

describe Economic::Account do
  let(:session) { make_session }
  subject { Economic::Account.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::Account.ancestors).to include(Economic::Entity)
  end

  describe "#save" do
    it 'should save it' do
      stub_request('Account_CreateFromData', nil, :success)
      subject.save
    end
  end
end
