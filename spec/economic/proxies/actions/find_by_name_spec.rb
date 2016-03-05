require "./spec/spec_helper"

describe Economic::Proxies::Actions::FindByName do
  let(:session) { make_session }
  let(:proxy) { Economic::CreditorContactProxy.new(session) }

  subject {
    Economic::Proxies::Actions::FindByName.new(proxy, "Bob")
  }

  describe "#call" do
    it "gets contact data from the API" do
      mock_request("CreditorContact_FindByName", {"name" => "Bob"}, :multiple)
      subject.call
    end

    it "returns creditor contacts" do
      stub_request("CreditorContact_FindByName", nil, :multiple)
      expect(subject.call.first).to be_instance_of(Economic::CreditorContact)
    end

    it "returns empty when nothing is found" do
      stub_request("CreditorContact_FindByName", nil, :none)
      expect(subject.call).to be_empty
    end

    context "when calling proxy is owned by session" do
      it "returns all creditor contacts" do
        stub_request("CreditorContact_FindByName", nil, :multiple)
        expect(subject.call.size).to eq(2)
      end
    end

    context "when calling proxy is owned by a creditor" do
      it "returns only contacts for creditor" do
        # Note the order of these stubs actually matters. They need to match
        # the order they are called in in the implementation
        stub_request("CreditorContact_FindByName", nil, :multiple)
        stub_request("CreditorContact_GetData", nil, :success)
        stub_request("Creditor_GetData", nil, :success)
        stub_request("CreditorContact_GetData", nil, :success)
        stub_request("Creditor_GetData", nil, :success)
        creditor = session.creditors.build
        proxy = Economic::CreditorContactProxy.new(creditor)
        action = Economic::Proxies::Actions::FindByName.new(proxy, "Bob")
        action.call.each { |contact| expect(contact.creditor).to eq(creditor) }
      end
    end
  end
end
