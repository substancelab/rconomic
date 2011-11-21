require 'economic/proxies/entity_proxy'

module Economic
  class CashBookEntryProxy < EntityProxy
    def all
      entity_hash = session.request(CashBookProxy.entity_class.soap_action(:get_entries)) do
        soap.body = { "cashBookHandle" => owner.handle.to_hash }
      end
      if entity_hash != {}
        [ entity_hash.values.first ].flatten.each do |id_hash|
          find(id_hash)
        end
      end
      self
    end

    # Creates a finance voucher and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_finance_voucher(
    #     :account_handle        => { :number => 1010 },
    #     :contra_account_handle => { :number => 1011 }
    #   )
    def create_finance_voucher(handles)
      response = session.request(entity_class.soap_action('CreateFinanceVoucher')) do
        soap.body = {
          'cashBookHandle'      => { 'Number' => owner.handle[:number] },
          'accountHandle'       => { 'Number'  => handles[:account_handle][:number] },
          'contraAccountHandle' => { 'Number'  => handles[:contra_account_handle][:number] },
          :order! => ['cashBookHandle', 'accountHandle', 'contraAccountHandle']
        }
      end

      find(response)
    end

    # Creates a debtor payment and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_debtor_payment(
    #     :debtor_handle         => { :number => 1 },
    #     :contra_account_handle => { :number => 1510 }
    #   )
    def create_debtor_payment(handles)
      response = session.request(entity_class.soap_action('CreateDebtorPayment')) do
        soap.body = {
          "cashBookHandle"      => { 'Number' => owner.handle[:number] },
          "debtorHandle"        => { 'Number' => handles[:debtor_handle][:number] },
          "contraAccountHandle" => { 'Number' => handles[:contra_account_handle][:number] },
          :order! => ['cashBookHandle', 'debtorHandle', 'contraAccountHandle']
        }
      end

      find(response)
    end

    # Creates a creditor payment and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_creditor_payment(
    #     :creditor_handle       => { :number => 1 },
    #     :contra_account_handle => { :number => 1510 }
    #   )
    def create_creditor_payment(handles)
      response = session.request(entity_class.soap_action('CreateCreditorPayment')) do
        soap.body = {
          "cashBookHandle"      => { 'Number' => owner.handle[:number] },
          "creditorHandle"      => { 'Number' => handles[:creditor_handle][:number] },
          "contraAccountHandle" => { 'Number' => handles[:contra_account_handle][:number] },
          :order! => ['cashBookHandle', 'creditorHandle', 'contraAccountHandle']
        }
      end

      find(response)
    end

    # Creates a creditor invoice and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_creditor_invoice(
    #     :creditor_handle       => { :number => 1 },
    #     :contra_account_handle => { :number => 1510 }
    #   )
    def create_creditor_invoice(handles)
      response = session.request(entity_class.soap_action('CreateCreditorInvoice')) do
        soap.body = {
          "cashBookHandle"      => { 'Number' => owner.handle[:number] },
          "creditorHandle"      => { 'Number' => handles[:creditor_handle][:number] },
          "contraAccountHandle" => { 'Number' => handles[:contra_account_handle][:number] },
          :order! => ['cashBookHandle', 'creditorHandle', 'contraAccountHandle']
        }
      end

      find(response)
    end

  end
end
