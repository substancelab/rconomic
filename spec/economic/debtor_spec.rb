require './spec/spec_helper'

describe Economic::Debtor do
  let(:session) { make_session }
  subject { Economic::Debtor.new(:session => session) }

  it "inherits from Economic::Entity" do
    Economic::Debtor.ancestors.should include(Economic::Entity)
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

end
