require './spec/spec_helper'

describe Economic::Proxies::Actions::CreditorContactProxy::FindByName do
  let(:session) { make_session }
  let(:proxy) { Economic::CreditorContactProxy.new(session) }

  subject {
    Economic::Proxies::Actions::CreditorContactProxy::FindByName.new(proxy, "Bob")
  }

  describe "#call" do
    before :each do
      savon.stubs('CreditorContact_FindByName').returns(:multiple)
    end

    it "gets contact data from the API" do
      savon.expects('CreditorContact_FindByName').with('name' => 'Bob').returns(:multiple)
      subject.call
    end

    it "returns creditor contacts" do
      subject.call.first.should be_instance_of(Economic::CreditorContact)
    end

    it "returns each contact" do
      subject.call.size.should == 2
    end

    it "returns empty when nothing is found" do
      savon.stubs('CreditorContact_FindByName').returns(:none)
      subject.call.should be_empty
    end
  end
end

