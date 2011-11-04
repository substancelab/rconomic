require './spec/spec_helper'

describe Economic::CashBookEntryProxy do

  let(:session) { make_session }
  let(:cash_book) { Economic::CashBook.new(:session => session) }
  subject { Economic::CashBookEntryProxy.new(cash_book) }

  describe ".new" do
    it "stores owner" do
      subject.owner.should == cash_book
    end

    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new CashBookEntry" do
      subject.build.should be_instance_of(Economic::CashBookEntry)
    end

    it "assigns the session to the CashBookEntry" do
      subject.build.session.should === session
    end
  end

  describe "#save" do
    it 'should save it' do
      savon.stubs('CashBookEntry_CreateFromData').returns(:success)
      subject.build.save
    end
  end

  describe ".create_finance_voucher" do
    pending "should either be removed or fixed because of hard-coded values"
  end

end
