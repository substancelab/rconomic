require './spec/spec_helper'

describe Economic::CurrentInvoiceProxy do
  let(:session) { stub_session }
  subject { Economic::CurrentInvoiceProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe "build" do
    it "instantiates a new CurrentInvoice" do
      subject.build.should be_instance_of(Economic::CurrentInvoice)
    end

    it "assigns the session to the CurrentInvoice" do
      subject.build.session.should === session
    end
  end
end