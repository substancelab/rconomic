require './spec/spec_helper'

describe Economic::Proxies::Actions::DebtorContactProxy::FindByName do
  let(:session) { make_session }
  let(:proxy) { Economic::DebtorContactProxy.new(session) }

  subject {
    Economic::Proxies::Actions::DebtorContactProxy::FindByName.new(proxy, "Bob")
  }

  describe "#call" do
    before :each do
      savon.stubs('DebtorContact_FindByName').returns(:multiple)
    end

    it "gets contact data from the API" do
      savon.expects('DebtorContact_FindByName').with('name' => 'Bob').returns(:multiple)
      subject.call
    end

    it "returns debtor contacts" do
      subject.call.first.should be_instance_of(Economic::DebtorContact)
    end

    it "returns empty when nothing is found" do
      savon.stubs('DebtorContact_FindByName').returns(:none)
      subject.call.should be_empty
    end

    context "when calling proxy is owned by session" do
      it "returns all debtor contacts" do
        subject.call.size.should == 2
      end
    end

    context "when calling proxy is owned by a debtor" do
      it "returns only contacts for debtor" do
        savon.stubs("DebtorContact_GetData").returns(:success)
        savon.stubs("Debtor_GetData").returns(:success)
        debtor = session.debtors.build
        proxy = Economic::DebtorContactProxy.new(debtor)
        action = Economic::Proxies::Actions::DebtorContactProxy::FindByName.new(proxy, "Bob")
        action.call.each { |contact| contact.debtor.should == debtor }
      end
    end
  end
end
