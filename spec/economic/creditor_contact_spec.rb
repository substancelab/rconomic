require "./spec/spec_helper"

describe Economic::CreditorContact do
  let(:session) { make_session }
  subject { Economic::CreditorContact.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::CreditorContact.ancestors).to include(Economic::Entity)
  end

  context "when saving" do
    context "when creditor contact is new" do
      subject { Economic::CreditorContact.new(:session => session) }

      context "when creditor_handle is nil" do
        before :each do
          subject.creditor_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          expect(session).to receive(:request)
          subject.save
        end
      end
    end

    it "builds and sends data to API" do
      mock_request(
        :creditor_contact_create_from_data,
        {"data" => {"Handle" => {}, "Number" => nil}},
        :success
      )
      subject.save
    end
  end

  describe ".creditor" do
    context "when creditor_handle is not set" do
      it "returns nil" do
        expect(subject.creditor).to be_nil
      end
    end

    context "when creditor_handle is set" do
      let(:handle) { Economic::CreditorContact::Handle.new(:number => 42) }

      before :each do
        subject.creditor_handle = handle
      end

      it "returns a Creditor" do
        expect(session.creditors).to receive(:find).with(42).and_return(Economic::Creditor.new)
        expect(subject.creditor).to be_instance_of(Economic::Creditor)
      end

      it "only looks up the creditor the first time" do
        expect(session.creditors).to receive(:find).with(42).and_return(Economic::Creditor.new)
        expect(subject.creditor).to equal(subject.creditor)
      end
    end
  end

  describe ".creditor=" do
    let(:creditor) { make_creditor }
    it "should set creditor_handle" do
      subject.creditor = creditor
      expect(subject.creditor_handle).to eq(creditor.handle)
    end
  end

  describe ".creditor_handle=" do
    let(:creditor) { make_creditor }
    let(:handle) { creditor.handle }

    it "should set creditor_handle" do
      subject.creditor_handle = handle
      expect(subject.creditor_handle).to eq(handle)
    end

    context "when creditor handle is for a different Creditor" do
      before :each do
        subject.creditor = creditor
      end

      it "should clear cached creditor and fetch the new creditor from API" do
        stub_request("Creditor_GetData", nil, :success)
        subject.creditor_handle = Economic::Creditor::Handle.new(:number => 1234)
        expect(subject.creditor).to be_instance_of(Economic::Creditor)
      end
    end

    context "when creditor handle is for the current Creditor" do
      before :each do
        subject.creditor = creditor
      end

      it "should not clear cached creditor nor fetch the creditor from API" do
        expect(session).to receive(:request).never
        subject.creditor_handle = handle
        expect(subject.creditor).to be_instance_of(Economic::Creditor)
      end
    end
  end

  describe ".proxy" do
    it "should return a CreditorContactProxy" do
      expect(subject.proxy).to be_instance_of(Economic::CreditorContactProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
