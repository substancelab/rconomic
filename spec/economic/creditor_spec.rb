require "./spec/spec_helper"

describe Economic::Creditor do
  let(:session) { make_session }
  subject { Economic::Creditor.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::Creditor.ancestors).to include(Economic::Entity)
  end

  describe "class methods" do
    subject { Economic::Creditor }

    describe ".proxy" do
      it "should return CreditorProxy" do
        expect(subject.proxy).to eq(Economic::CreditorProxy)
      end
    end

    describe ".key" do
      it "should == :creditor" do
        expect(Economic::Creditor.key).to eq(:creditor)
      end
    end
  end

  describe ".contacts" do
    it "returns a CreditorContactProxy" do
      expect(subject.contacts).to be_instance_of(Economic::CreditorContactProxy)
    end

    it "memoizes the proxy" do
      expect(subject.contacts).to equal(subject.contacts)
    end

    it "should store the session" do
      expect(subject.session).to_not be_nil
      expect(subject.contacts.session).to eq(subject.session)
    end
  end

  describe ".proxy" do
    it "should return a CreditorProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CreditorProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end

  describe "#save" do
    it "should save it" do
      stub_request("Creditor_CreateFromData", nil, :success)
      subject.save
    end

    it "builds and sends data to API" do
      mock_request(
        :creditor_create_from_data, {
          "data" => {
            "Handle" => {},
            "Number" => nil
          }
        },
        :success
      )
      subject.save
    end
  end
end
