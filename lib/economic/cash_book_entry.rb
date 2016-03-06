require "economic/entity"

module Economic
  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBookEntry < Entity
    has_properties :id1,
      :id2,
      :account_handle,
      :amount,
      :amount_default_currency,
      :bank_payment_creditor_id,
      :bank_payment_creditor_invoice_id,
      :bank_payment_type_handle,
      :capitalise_handle,
      :cash_book_handle,
      :contra_account_handle,
      :contra_vat_account_handle,
      :cost_type_handle,
      :creditor_handle,
      :creditor_invoice_number,
      :currency_handle,
      :date,
      :debtor_handle,
      :debtor_invoice_number,
      :department_handle,
      :distribution_key_handle,
      :due_date,
      :employee_handle,
      :end_date,
      :project_handle,
      :start_date,
      :text,
      :type,
      :vat_account_handle,
      :voucher_number

    defaults(
      :amount => 0,
      :amount_default_currency => 0,
      :date => Time.now,
      :start_date => Time.now,
      :text => "",
      :type => "",
      :voucher_number => 0
    )

    def handle
      @handle || Handle.new(:id1 => @id1, :id2 => @id2)
    end

    protected

    def fields
      to_hash = proc { |handle| handle.to_hash }
      [
        ["Handle", :handle, proc { |v| v.to_hash }],
        ["Id1", :id1],
        ["Id2", :id2],
        ["Type", :type],
        ["CashBookHandle", :cash_book_handle, to_hash],
        ["DebtorHandle", :debtor_handle, to_hash],
        ["CreditorHandle", :creditor_handle, to_hash],
        ["AccountHandle", :account_handle, to_hash],
        ["ContraAccountHandle", :contra_account_handle, to_hash],
        ["Date", :date, nil, :required],
        ["VoucherNumber", :voucher_number, nil, :required],
        ["Text", :text, nil, :required],
        ["AmountDefaultCurrency", :amount_default_currency, nil, :required],
        ["CurrencyHandle", :currency_handle, to_hash],
        ["Amount", :amount, nil, :required],
        ["VatAccountHandle", :vat_account_handle, to_hash],
        ["ContraVatAccountHandle", :contra_vat_account_handle, to_hash],
        ["DebtorInvoiceNumber", :debtor_invoice_number],
        ["CreditorInvoiceNumber", :creditor_invoice_number],
        ["DueDate", :due_date, nil, :required],
        ["DepartmentHandle", :department_handle, to_hash],
        ["DistributionKeyHandle", :distribution_key_handle, to_hash],
        ["ProjectHandle", :project_handle, to_hash],
        ["CostTypeHandle", :cost_type_handle, to_hash],
        ["BankPaymentTypeHandle", :bank_payment_type_handle, to_hash],
        ["BankPaymentCreditorId", :bank_payment_creditor_id],
        ["BankPaymentCreditorInvoiceId", :bank_payment_creditor_invoice_id],
        ["CapitaliseHandle", :capitalise_handle, to_hash],
        ["StartDate", :start_date, nil, :required],
        ["EndDate", :end_date, nil, :required],
        ["EmployeeHandle", :employee_handle, to_hash]
      ]
    end
  end
end
