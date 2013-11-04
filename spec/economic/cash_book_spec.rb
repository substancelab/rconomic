require './spec/spec_helper'

describe Economic::CashBook do
  let(:session) { make_session }
  subject { (i = Economic::CashBook.new( :id => 512, :number => 32 )).tap { i.session = session } }

  it "inherits from Economic::Entity" do
    expect(Economic::CashBook.superclass).to eq(Economic::Entity)
  end

  describe "class methods" do
    subject { Economic::CashBook }

    describe ".proxy" do
      it "should return CashBookProxy" do
        expect(subject.proxy).to eq(Economic::CashBookProxy)
      end
    end
  end

  describe "#entries" do
    it 'should return a cash book entry proxy' do
      expect(subject.entries).to be_a(Economic::CashBookEntryProxy)
      expect(subject.entries.owner).to eq(subject)
    end
  end

  describe "#book" do
    it 'should book the cash book and return an invoice number' do
      mock_request("CashBook_Book", {'cashBookHandle' => { 'Number' => 32 }}, :success)
      expect(subject.book).to eq(832)
    end
  end
end
