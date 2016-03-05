require "./spec/spec_helper"

describe Economic::DebtorContact do
  let(:session) { make_session }
  subject { Economic::DebtorContact.new(:session => session) }

  it "inherits from Economic::Entity" do
    expect(Economic::DebtorContact.ancestors).to include(Economic::Entity)
  end

  context "when saving" do
    context "when debtor contact is new" do
      subject { Economic::DebtorContact.new(:session => session) }

      context "when debtor_handle is nil" do
        before :each do
          subject.debtor_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          expect(session).to receive(:request)
          subject.save
        end
      end
    end

    it "builds and sends data to API" do
      mock_request(
        :debtor_contact_create_from_data,
        {"data" => {"Handle" => {}, "Id" => nil, "Name" => nil, "Number" => 42, "IsToReceiveEmailCopyOfOrder" => false, "IsToReceiveEmailCopyOfInvoice" => false}},
        :success
      )
      subject.number = 42
      subject.save
    end
  end

  describe ".debtor" do
    context "when debtor_handle is not set" do
      it "returns nil" do
        expect(subject.debtor).to be_nil
      end
    end

    context "when debtor_handle is set" do
      let(:handle) { Economic::DebtorContact::Handle.new(:number => 42) }

      before :each do
        subject.debtor_handle = handle
      end

      it "returns a Debtor" do
        expect(session.debtors).to receive(:find).with(42).and_return(Economic::Debtor.new)
        expect(subject.debtor).to be_instance_of(Economic::Debtor)
      end

      it "only looks up the debtor the first time" do
        expect(session.debtors).to receive(:find).with(42).and_return(Economic::Debtor.new)
        expect(subject.debtor).to equal(subject.debtor)
      end
    end
  end

  describe ".debtor=" do
    let(:debtor) { make_debtor }
    it "should set debtor_handle" do
      subject.debtor = debtor
      expect(subject.debtor_handle).to eq(debtor.handle)
    end
  end

  describe ".debtor_handle=" do
    let(:debtor) { make_debtor }
    let(:handle) { debtor.handle }

    it "should set debtor_handle" do
      subject.debtor_handle = handle
      expect(subject.debtor_handle).to eq(handle)
    end

    context "when debtor handle is for a different Debtor" do
      before :each do
        subject.debtor = debtor
      end

      it "should clear cached debtor and fetch the new debtor from API" do
        stub_request("Debtor_GetData", nil, :success)
        subject.debtor_handle = Economic::Debtor::Handle.new(:number => 1234)
        expect(subject.debtor).to be_instance_of(Economic::Debtor)
      end
    end

    context "when debtor handle is for the current Debtor" do
      before :each do
        subject.debtor = debtor
      end

      it "should not clear cached debtor nor fetch the debtor from API" do
        expect(session).to receive(:request).never
        subject.debtor_handle = handle
        expect(subject.debtor).to be_instance_of(Economic::Debtor)
      end
    end
  end

  describe ".proxy" do
    it "should return a DebtorContactProxy" do
      expect(subject.proxy).to be_instance_of(Economic::DebtorContactProxy)
    end

    it "should return a proxy owned by session" do
      expect(subject.proxy.session).to eq(session)
    end
  end
end
