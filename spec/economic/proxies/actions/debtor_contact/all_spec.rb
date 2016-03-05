require "./spec/spec_helper"

describe Economic::Proxies::Actions::DebtorContact::All do
  let(:session) { make_session }
  let(:proxy) { Economic::DebtorContactProxy.new(session) }

  subject {
    Economic::Proxies::Actions::DebtorContact::All.new(proxy)
  }

  before :each do
    allow(session).to receive(:number) { 123 }
  end

  describe "#call" do
    it "returns debtor contacts" do
      stub_request("Debtor_GetDebtorContacts", nil, :multiple)
      expect(subject.call.first).to be_instance_of(Economic::DebtorContact)
    end

    it "returns empty array when nothing is found" do
      stub_request("Debtor_GetDebtorContacts", nil, :none)
      expect(subject.call).to be_empty
    end
  end
end
