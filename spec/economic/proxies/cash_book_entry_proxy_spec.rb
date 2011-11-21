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

  describe "#create_finance_voucher" do
    it 'should create a finance voucher and return the created cash book entry' do
      savon.stubs('CashBookEntry_CreateFinanceVoucher').returns(:success)
      savon.stubs('CashBookEntry_GetData').with(:id1 => 15, :id2 => 16).returns(:success)
      cash_book_entry = subject.create_finance_voucher(:account_handle => { :number => 2 }, :contra_account_handle => { :number => 3 })
      cash_book_entry.should be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#create_debtor_payment" do
    it 'should create a debtor payment and then return the created cash book entry' do
      savon.stubs('CashBookEntry_CreateDebtorPayment').returns(:success)
      savon.stubs('CashBookEntry_GetData').with(:id1 => 13, :id2 => 14).returns(:success)
      cash_book_entry = subject.create_debtor_payment(:debtor_handle => { :number => 2 }, :contra_account_handle => { :number => 3 })
      cash_book_entry.should be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#create_creditor_invoice" do
    it 'should create a creditor invoice and then return the created cash book entry' do
      savon.stubs('CashBookEntry_CreateCreditorInvoice').returns(:success)
      savon.stubs('CashBookEntry_GetData').with(:id1 => 13, :id2 => 14).returns(:success)
      cash_book_entry = subject.create_creditor_invoice(:creditor_handle => { :number => 2 }, :contra_account_handle => { :number => 3 })
      cash_book_entry.should be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#create_creditor_payment" do
    it 'should create a creditor payment and then return the created cash book entry' do
      savon.stubs('CashBookEntry_CreateCreditorPayment').returns(:success)
      savon.stubs('CashBookEntry_GetData').with(:id1 => 13, :id2 => 14).returns(:success)
      cash_book_entry = subject.create_creditor_payment(:creditor_handle => { :number => 2 }, :contra_account_handle => { :number => 3 })
      cash_book_entry.should be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#all" do
    it 'should get the cash book entries' do
      savon.stubs('CashBook_GetEntries').returns(:success)
      savon.stubs('CashBookEntry_GetData').returns(:success)
      subject.all.size.should == 2
    end
  end

end
