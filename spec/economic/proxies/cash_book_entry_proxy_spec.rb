require "./spec/spec_helper"

describe Economic::CashBookEntryProxy do
  let(:session) { make_session }
  let(:cash_book) { Economic::CashBook.new(:session => session) }
  subject { Economic::CashBookEntryProxy.new(cash_book) }

  describe ".new" do
    it "stores owner" do
      subject.owner.number = 2
      expect(subject.owner).to eq(cash_book)
    end

    it "stores session" do
      expect(subject.session).to equal(session)
    end
  end

  describe ".build" do
    it "instantiates a new CashBookEntry" do
      expect(subject.build).to be_instance_of(Economic::CashBookEntry)
    end

    it "assigns the session to the CashBookEntry" do
      expect(subject.build.session).to equal(session)
    end
  end

  describe "#create_finance_voucher" do
    it "should create a finance voucher and return the created cash book entry" do
      stub_request("CashBookEntry_CreateFinanceVoucher", nil, :success)
      stub_request("CashBookEntry_GetData", {"entityHandle" => {"Id1" => 15, "Id2" => 16}}, :success)
      cash_book_entry = subject.create_finance_voucher(:account_handle => {:number => 2}, :contra_account_handle => {:number => 3})
      expect(cash_book_entry).to be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#create_debtor_payment" do
    it "should create a debtor payment and then return the created cash book entry" do
      stub_request("CashBookEntry_CreateDebtorPayment", nil, :success)
      stub_request("CashBookEntry_GetData", {"entityHandle" => {"Id1" => 13, "Id2" => 14}}, :success)
      cash_book_entry = subject.create_debtor_payment(:debtor_handle => {:number => 2}, :contra_account_handle => {:number => 3})
      expect(cash_book_entry).to be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#create_creditor_invoice" do
    it "should create a creditor invoice and then return the created cash book entry" do
      stub_request("CashBookEntry_CreateCreditorInvoice", nil, :success)
      stub_request("CashBookEntry_GetData", {"entityHandle" => {"Id1" => 13, "Id2" => 14}}, :success)
      cash_book_entry = subject.create_creditor_invoice(:creditor_handle => {:number => 2}, :contra_account_handle => {:number => 3})
      expect(cash_book_entry).to be_instance_of(Economic::CashBookEntry)
    end

    it "should not send handles that were not given" do
      stub_request("CashBookEntry_CreateCreditorInvoice", {"cashBookHandle" => {"Number" => 42}}, :success)
      stub_request("CashBookEntry_GetData", {"entityHandle" => {"Id1" => 13, "Id2" => 14}}, :success)
      cash_book.number = 42
      cash_book_entry = subject.create_creditor_invoice(:number => 13)
      expect(cash_book_entry).to be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#create_creditor_payment" do
    it "should create a creditor payment and then return the created cash book entry" do
      stub_request("CashBookEntry_CreateCreditorPayment", nil, :success)
      stub_request("CashBookEntry_GetData", {"entityHandle" => {"Id1" => 13, "Id2" => 14}}, :success)
      cash_book_entry = subject.create_creditor_payment(:creditor_handle => {:number => 2}, :contra_account_handle => {:number => 3})
      expect(cash_book_entry).to be_instance_of(Economic::CashBookEntry)
    end
  end

  describe "#set_due_date" do
    it "should set due date" do
      mock_request("CashBookEntry_SetDueDate", {"cashBookEntryHandle" => {"Id1" => subject.owner.id, "Id2" => 234}, :value => Date.new(2012, 12, 21)}, :success)
      subject.set_due_date(234, Date.new(2012, 12, 21))
    end
  end

  describe "#all" do
    it "should get the cash book entries" do
      stub_request("CashBook_GetEntries", nil, :success)
      expect(subject).to receive(:find).with(:id1 => "1", :id2 => "2")
      expect(subject).to receive(:find).with(:id1 => "11", :id2 => "12")
      subject.all
    end
  end
end
