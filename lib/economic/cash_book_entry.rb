require "economic/entity"

module Economic
  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBookEntry < Entity
    property(:handle, :formatter => Properties::Formatters::HANDLE)
    property(:id1)
    property(:id2)
    property(:type, :default => "")
    property(:cash_book_handle, :formatter => Properties::Formatters::HANDLE)
    property(:debtor_handle, :formatter => Properties::Formatters::HANDLE)
    property(:creditor_handle, :formatter => Properties::Formatters::HANDLE)
    property(:account_handle, :formatter => Properties::Formatters::HANDLE)
    property(:contra_account_handle, :formatter => Properties::Formatters::HANDLE)
    property(:date, :default => Time.now, :required => true)
    property(:voucher_number, :default => 0, :required => true)
    property(:text, :default => "", :required => true)
    property(:amount_default_currency, :default => 0, :required => true)
    property(:currency_handle, :formatter => Properties::Formatters::HANDLE)
    property(:amount, :default => 0, :required => true)
    property(:vat_account_handle, :formatter => Properties::Formatters::HANDLE)
    property(:contra_vat_account_handle, :formatter => Properties::Formatters::HANDLE)
    property(:debtor_invoice_number)
    property(:creditor_invoice_number)
    property(:due_date, :required => true)
    property(:department_handle, :formatter => Properties::Formatters::HANDLE)
    property(:distribution_key_handle, :formatter => Properties::Formatters::HANDLE)
    property(:project_handle, :formatter => Properties::Formatters::HANDLE)
    property(:cost_type_handle, :formatter => Properties::Formatters::HANDLE)
    property(:bank_payment_type_handle, :formatter => Properties::Formatters::HANDLE)
    property(:bank_payment_creditor_id)
    property(:bank_payment_creditor_invoice_id)
    property(:capitalise_handle, :formatter => Properties::Formatters::HANDLE)
    property(:start_date, :default => Time.now, :required => true)
    property(:end_date, :required => true)
    property(:employee_handle, :formatter => Properties::Formatters::HANDLE)

    def handle
      @handle || Handle.new(:id1 => @id1, :id2 => @id2)
    end
  end
end
