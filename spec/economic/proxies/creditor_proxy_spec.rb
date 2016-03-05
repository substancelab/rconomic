require "./spec/spec_helper"

describe Economic::CreditorProxy do
  let(:session) { make_session }
  subject { Economic::CreditorProxy.new(session) }

  describe "new" do
    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe "find" do
    it "gets creditor data from API" do
      mock_request("Creditor_GetData", {"entityHandle" => {"Number" => 42}}, :success)
      subject.find(42)
    end

    it "returns Creditor object" do
      stub_request("Creditor_GetData", nil, :success)
      expect(subject.find(42)).to be_instance_of(Economic::Creditor)
    end
  end

  describe "find_by_number" do
    it "can find a creditor" do
      mock_request("Creditor_FindByNumber", {"number" => "1"}, :found)
      result = subject.find_by_number("1")
      expect(result).to be_instance_of(Economic::Creditor)
      expect(result.partial).to be_truthy
      expect(result.persisted).to be_truthy
      expect(result.number).to eq("1")
      expect(result.handle).to eq(Economic::Entity::Handle.new(:number => "1"))
    end

    it "returns nil when there is no creditor" do
      mock_request("Creditor_FindByNumber", {"number" => "1"}, :not_found)
      result = subject.find_by_number("1")
      expect(result).to be_nil
    end
  end

  describe "build" do
    subject { session.creditors.build }

    it "instantiates a new Creditor" do
      expect(subject).to be_instance_of(Economic::Creditor)
    end

    it "assigns the session to the Creditor" do
      expect(subject.session).to equal(session)
    end
  end

  describe "#entity_class" do
    it "should return Economic::Creditor" do
      expect(Economic::CreditorProxy.entity_class).to eq(Economic::Creditor)
    end
  end

  describe ".all" do
    it "returns a single creditor" do
      stub_request("Creditor_GetAll", nil, :single)
      mock_request("Creditor_GetData", {"entityHandle" => {"Number" => "1"}}, :success)
      all = subject.all
      expect(all.size).to eq(1)
      expect(all.first).to be_instance_of(Economic::Creditor)
    end

    it "returns multiple creditors" do
      mock_request("Creditor_GetAll", nil, :multiple)
      stub_request("Creditor_GetDataArray", nil, :multiple)
      all = subject.all
      expect(all.size).to eq(2)
      expect(all.first).to be_instance_of(Economic::Creditor)
    end
  end
end
