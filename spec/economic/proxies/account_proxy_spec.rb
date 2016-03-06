require "./spec/spec_helper"

describe Economic::AccountProxy do
  let(:session) { make_session }
  subject { Economic::AccountProxy.new(session) }

  describe ".new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new Account" do
      expect(subject.build).to be_instance_of(Economic::Account)
    end

    it "assigns the session to the Account" do
      expect(subject.build.session).to equal(session)
    end

    it "should not build a partial Account" do
      expect(subject.build).to_not be_partial
    end
  end

  describe ".find" do
    it "gets account data from API" do
      mock_request(
        "Account_GetData",
        {"entityHandle" => {"Id" => 42}},
        :success
      )
      subject.find(42)
    end

    it "returns Account object" do
      stub_request("Account_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::Account)
    end
  end

  describe ".all" do
    it "returns an empty array when there are no accounts" do
      stub_request("Account_GetAll", nil, :none)
      expect(subject.all.size).to eq(0)
    end

    it "finds and adds a single account" do
      stub_request("Account_GetAll", nil, :single)
      mock_request(
        "Account_GetData",
        {"entityHandle" => {"Number" => "1"}},
        :success
      )

      accounts = subject.all
      expect(accounts).to be_instance_of(Economic::AccountProxy)

      expect(accounts.size).to eq(1)
      expect(accounts.first).to be_instance_of(Economic::Account)
    end

    it "adds multiple accounts" do
      stub_request("Account_GetAll", nil, :multiple)
      stub_request("Account_GetDataArray", nil, :multiple)

      accounts = subject.all
      expect(accounts.size).to eq(2)
      expect(accounts.first).to be_instance_of(Economic::Account)
      expect(accounts.last).to be_instance_of(Economic::Account)
    end
  end
end
