require 'spec/spec_helper'

describe Economic::CurrentInvoiceLine do
  let(:session) { stub_session }
  subject { (l = Economic::CurrentInvoiceLine.new).tap { l.session = session } }

  it "inherits from Economic::Entity" do
    Economic::CurrentInvoiceLine.ancestors.should include(Economic::Entity)
  end
end
