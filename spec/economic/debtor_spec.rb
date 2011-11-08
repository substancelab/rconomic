require './spec/spec_helper'

describe Economic::Debtor do
  let(:session) { make_session }
  subject { Economic::Debtor.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::Debtor.ancestors.should include(Economic::Entity)
  end

  describe "class methods" do
    subject { Economic::Debtor }

    describe ".proxy" do
      it "should return DebtorProxy" do
        subject.proxy.should == Economic::DebtorProxy
      end
    end

    describe ".key" do
      it "should == :debtor" do
        Economic::Debtor.key.should == :debtor
      end
    end
  end

  context "when saving" do
    context "when debtor is new" do
      subject { Economic::Debtor.new(:session => session) }

      context "when debtor_group_handle is nil" do
        before :each do
          subject.debtor_group_handle = nil
        end

        it "should send request and let e-conomic return an error" do
          session.expects(:request)
          subject.save
        end
      end
    end
  end

  describe ".current_invoices" do
    it "returns an CurrentInvoiceProxy" do
      subject.current_invoices.should be_instance_of(Economic::CurrentInvoiceProxy)
    end

    it "memoizes the proxy" do
      subject.current_invoices.should === subject.current_invoices
    end

    it "should store the session" do
      subject.session.should_not be_nil
      subject.current_invoices.session.should == subject.session
    end
  end

  describe ".contacts" do
    it "returns a DebtorContactProxy" do
      subject.contacts.should be_instance_of(Economic::DebtorContactProxy)
    end

    it "memoizes the proxy" do
      subject.contacts.should === subject.contacts
    end

    it "should store the session" do
      subject.session.should_not be_nil
      subject.contacts.session.should == subject.session
    end
  end

  describe ".proxy" do
    it "should return a DebtorProxy" do
      subject.proxy.should be_instance_of(Economic::DebtorProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

end
