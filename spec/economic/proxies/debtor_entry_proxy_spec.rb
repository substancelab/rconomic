require './spec/spec_helper'

describe Economic::DebtorEntryProxy do
  let(:session) { make_session }
  subject { Economic::DebtorEntryProxy.new(session) }

  describe "new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".find_by_invoice_number" do
    it 'should be able to find multiple debtor entries' do
      savon.expects("DebtorEntry_FindByInvoiceNumber").with('from' => '123', 'to' => '456', :order! => ['from', 'to']).returns(:many)
      subject.find_by_invoice_number('123', '456').should == [1, 2]
    end

    it 'should be able to find debtor entries with one invoice id' do
      savon.expects("DebtorEntry_FindByInvoiceNumber").with('from' => '123', 'to' => '123', :order! => ['from', 'to']).returns(:many)
      subject.find_by_invoice_number('123').should == [1, 2]
    end

    it 'should handle a single serial number in the response' do
      savon.stubs("DebtorEntry_FindByInvoiceNumber").returns(:single)
      subject.find_by_invoice_number('123').should == [1]
    end
  end

  describe ".match" do
    it 'should match two debtor entries by serial numbers' do
      savon.stubs("DebtorEntry_MatchEntries").with(
        :entries => [
          { :debtor_entry_handle => { :serial_number => 1 } },
          { :debtor_entry_handle => { :serial_number => 2 } }
        ]
      ).returns(:success)
      subject.match(1, 2)
    end
  end

  describe "#entity_class" do
    it "should return Economic::DebtorEntry" do
      Economic::DebtorEntryProxy.entity_class.should == Economic::DebtorEntry
    end
  end
end
