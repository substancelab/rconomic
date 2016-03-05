require "./spec/spec_helper"

describe Economic::CreditorContactProxy do
  let(:session) { make_session }
  subject { Economic::CreditorContactProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new CreditorContact" do
      expect(subject.build).to be_instance_of(Economic::CreditorContact)
    end

    it "assigns the session to the CreditorContact" do
      expect(subject.build.session).to equal(session)
    end

    it "should not build a partial CreditorContact" do
      expect(subject.build).to_not be_partial
    end

    context "when owner is a Creditor" do
      let(:creditor) { make_creditor(:session => session) }
      subject { creditor.contacts }

      it "should use the Creditors session" do
        expect(subject.build.session).to eq(creditor.session)
      end

      it "should initialize with values from Creditor" do
        contact = subject.build
        expect(contact.creditor_handle).to eq(creditor.handle)
      end
    end
  end

  describe ".find" do
    it "gets contact data from API" do
      mock_request(
        "CreditorContact_GetData",
        {"entityHandle" => {"Id" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns CreditorContact object" do
      stub_request("CreditorContact_GetData", nil, :success)
      expect(
        subject.find(42)
      ).to be_instance_of(Economic::CreditorContact)
    end
  end

  describe "#find_by_name" do
    it "uses the FindByName command" do
      expect(Economic::Proxies::Actions::FindByName).to receive(:new).
        with(subject, "Bob").
        and_return(-> { "Result" })
      expect(subject.find_by_name("Bob")).to eq("Result")
    end
  end
end
