require './spec/spec_helper'

describe Economic::CashBook do
  let(:session) { make_session }

  it "inherits from Economic::Entity" do
    Economic::CashBook.superclass.should == Economic::Entity
  end

  describe "class methods" do
    subject { Economic::CashBook }

    describe ".proxy" do
      it "should return CashBookProxy" do
        subject.proxy.should == Economic::CashBookProxy
      end
    end
  end

  describe "#entries" do
    subject { (i = Economic::CashBook.new( :id => 512 )).tap { i.session = session } }

    it 'should return a cash book entry proxy' do
      subject.entries.should be_a(Economic::CashBookEntryProxy)
      subject.entries.owner.should == subject
    end
  end
end
