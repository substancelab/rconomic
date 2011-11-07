require './spec/spec_helper'

describe Economic::Invoice do
  let(:session) { make_session }
  subject { Economic::Invoice.new(:session => session, :number => 13) }
  it "inherits from Economic::Entity" do
    Economic::Invoice.ancestors.should include(Economic::Entity)
  end

  describe '#remainder' do
    it 'should get the remainder' do
      savon.expects('Invoice_GetRemainder').with("invoiceHandle" => { "Number" => 13 }).returns(:success)
      subject.remainder.should == "512.32"
    end
  end
end
