require './spec/spec_helper'

describe Economic::CurrentInvoiceLine do
  let(:session) { make_session }
  subject { (l = Economic::CurrentInvoiceLine.new).tap { l.session = session } }

  it "inherits from Economic::Entity" do
    Economic::CurrentInvoiceLine.ancestors.should include(Economic::Entity)
  end

  describe ".proxy" do
    it "should return a CurrentInvoiceLineProxy" do
      subject.proxy.should be_instance_of(Economic::CurrentInvoiceLineProxy)
    end

    it "should return a proxy owned by session" do
      subject.proxy.session.should == session
    end
  end

end
