require "./spec/spec_helper"

describe Economic::DebtorContactProxy do
  let(:session) { make_session }
  subject { Economic::DebtorContactProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new DebtorContact" do
      expect(subject.build).to be_instance_of(Economic::DebtorContact)
    end

    it "assigns the session to the DebtorContact" do
      expect(subject.build.session).to equal(session)
    end

    it "should not build a partial DebtorContact" do
      expect(subject.build).to_not be_partial
    end

    context "when owner is a Debtor" do
      let(:debtor) { make_debtor(:session => session) }
      subject { Economic::DebtorContactProxy.new(debtor) }

      it "should use the Debtors session" do
        expect(subject.build.session).to eq(debtor.session)
      end

      it "should initialize with values from Debtor" do
        contact = subject.build
        expect(contact.debtor_handle).to eq(debtor.handle)
      end
    end
  end

  describe ".find" do
    it "gets contact data from API" do
      mock_request(
        "DebtorContact_GetData",
        {"entityHandle" => {"Id" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns DebtorContact object" do
      stub_request("DebtorContact_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::DebtorContact)
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
