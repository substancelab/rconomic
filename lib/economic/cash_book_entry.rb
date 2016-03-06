require "economic/entity"

module Economic
  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBookEntry < Entity
    property(:handle, :formatter => proc { |v| v.to_hash })
    property(:id1)
    property(:id2)
    property(:type, :default => "")
    property(:cash_book_handle, :formatter => proc { |handle| handle.to_hash })
    property(:debtor_handle, :formatter => proc { |handle| handle.to_hash })
    property(:creditor_handle, :formatter => proc { |handle| handle.to_hash })
    property(:account_handle, :formatter => proc { |handle| handle.to_hash })
    property(:contra_account_handle, :formatter => proc { |handle| handle.to_hash })
    property(:date, :default => Time.now, :required => true)
    property(:voucher_number, :default => 0, :required => true)
    property(:text, :default => "", :required => true)
    property(:amount_default_currency, :default => 0, :required => true)
    property(:currency_handle, :formatter => proc { |handle| handle.to_hash })
    property(:amount, :default => 0, :required => true)
    property(:vat_account_handle, :formatter => proc { |handle| handle.to_hash })
    property(:contra_vat_account_handle, :formatter => proc { |handle| handle.to_hash })
    property(:debtor_invoice_number)
    property(:creditor_invoice_number)
    property(:due_date, :required => true)
    property(:department_handle, :formatter => proc { |handle| handle.to_hash })
    property(:distribution_key_handle, :formatter => proc { |handle| handle.to_hash })
    property(:project_handle, :formatter => proc { |handle| handle.to_hash })
    property(:cost_type_handle, :formatter => proc { |handle| handle.to_hash })
    property(:bank_payment_type_handle, :formatter => proc { |handle| handle.to_hash })
    property(:bank_payment_creditor_id)
    property(:bank_payment_creditor_invoice_id)
    property(:capitalise_handle, :formatter => proc { |handle| handle.to_hash })
    property(:start_date, :default => Time.now, :required => true)
    property(:end_date, :required => true)
    property(:employee_handle, :formatter => proc { |handle| handle.to_hash })

    def handle
      @handle || Handle.new(:id1 => @id1, :id2 => @id2)
    end
  end
end
