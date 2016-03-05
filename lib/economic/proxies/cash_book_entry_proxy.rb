require "economic/proxies/entity_proxy"

module Economic
  class CashBookEntryProxy < EntityProxy
    def all
      entity_hash = session.request(
        Endpoint.new.soap_action_name(CashBook, :get_entries),
        "cashBookHandle" => owner.handle.to_hash
      )

      if entity_hash != {}
        [entity_hash.values.first].flatten.each do |id_hash|
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
      create_cash_book_entry_for_handles(handles, "CreateFinanceVoucher")
    end

    # Creates a debtor payment and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_debtor_payment(
    #     :debtor_handle         => { :number => 1 },
    #     :contra_account_handle => { :number => 1510 }
    #   )
    def create_debtor_payment(handles)
      create_cash_book_entry_for_handles(handles, "CreateDebtorPayment")
    end

    # Creates a creditor payment and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_creditor_payment(
    #     :creditor_handle       => { :number => 1 },
    #     :contra_account_handle => { :number => 1510 }
    #   )
    def create_creditor_payment(handles)
      create_cash_book_entry_for_handles(handles, "CreateCreditorPayment")
    end

    # Creates a creditor invoice and returns the cash book entry.
    # Example:
    #   cash_book.entries.create_creditor_invoice(
    #     :creditor_handle       => { :number => 1 },
    #     :contra_account_handle => { :number => 1510 }
    #   )
    def create_creditor_invoice(handles)
      create_cash_book_entry_for_handles(handles, "CreateCreditorInvoice")
    end

    def set_due_date(id, date)
      request("SetDueDate", "cashBookEntryHandle" => {
                "Id1" => owner.handle[:number], "Id2" => id
              },
                            :value => date)
    end

    protected

    def create_cash_book_entry_for_handles(handles, action, _foobar = nil)
      handle_name = handle_name_for_action(action)
      handle_key = Economic::Support::String.underscore(handle_name).intern

      data = {}
      data["cashBookHandle"] = {"Number" => owner.handle[:number]}
      data[handle_name] = {"Number" => handles[handle_key][:number]} if handles[handle_key]
      data["contraAccountHandle"] = {"Number" => handles[:contra_account_handle][:number]} if handles[:contra_account_handle]

      response = request(action, data)

      find(response)
    end

    def handle_name_for_action(action_name)
      {
        "CreateFinanceVoucher" => "accountHandle",
        "CreateDebtorPayment" => "debtorHandle",
        "CreateCreditorInvoice" => "creditorHandle",
        "CreateCreditorPayment" => "creditorHandle"
      }[action_name]
    end
  end
end
