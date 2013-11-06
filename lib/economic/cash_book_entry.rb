require 'economic/entity'

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
      :account_handle => nil,
      :amount => 0,
      :amount_default_currency => 0,
      :bank_payment_creditor_id => nil,
      :bank_payment_creditor_invoice_id => nil,
      :bank_payment_type_handle => nil,
      :capitalise_handle => nil,
      :cash_book_handle => nil,
      :contra_account_handle => nil,
      :contra_vat_account_handle => nil,
      :cost_type_handle => nil,
      :creditor_handle => nil,
      :creditor_invoice_number => nil,
      :currency_handle => nil,
      :date => Time.now,
      :debtor_handle => nil,
      :debtor_invoice_number => nil,
      :department_handle => nil,
      :distribution_key_handle => nil,
      :due_date => nil,
      :employee_handle => nil,
      :end_date => nil,
      :project_handle => nil,
      :start_date => Time.now,
      :text => "",
      :type => "",
      :vat_account_handle => nil,
      :voucher_number => 0
    )

    def handle
      @handle || Handle.new(:id1 => @id1, :id2 => @id2)
    end

    protected

    def build_soap_data
      Entity::Mapper.new(self, fields).to_hash
    end

    def fields
      hash_with_number = Proc.new { |handle| {"Number" => handle[:number]} }
      [
        ["Handle", :handle, Proc.new { |v| v.to_hash }],
        ["Id1", :id1],
        ["Id2", :id2],
        ["Type", :type],
        ["CashBookHandle", :cash_book_handle, hash_with_number],
        ["DebtorHandle", :debtor_handle, hash_with_number],
        ["AccountHandle", :account_handle, hash_with_number],
        ["ContraAccountHandle", :contra_account_handle, hash_with_number],
        ["Date", :date, nil, :required],
        ["VoucherNumber", :voucher_number, nil, :required],
        ["Text", :text, nil, :required],
        ["AmountDefaultCurrency", :amount_default_currency, nil, :required],
        ["CurrencyHandle", :currency_handle, Proc.new { |v| {"Code" => v[:code]} }],
        ["Amount", :amount, nil, :required],
        ["VatAccountHandle", :vat_account_handle, hash_with_number],
        ["ContraVatAccountHandle", :contra_vat_account_handle, hash_with_number],
        ["DebtorInvoiceNumber", :debtor_invoice_number],
        ["CreditorInvoiceNumber", :creditor_invoice_number],
        ["DueDate", :due_date, nil, :required],
        ["DepartmentHandle", :department_handle, hash_with_number],
        ["DistributionKeyHandle", :distribution_key_handle, hash_with_number],
        ["ProjectHandle", :project_handle, hash_with_number],
        ["CostTypeHandle", :cost_type_handle, hash_with_number],
        ["BankPaymentTypeHandle", :bank_payment_type_handle, hash_with_number],
        ["BankPaymentCreditorId", :bank_payment_creditor_id],
        ["BankPaymentCreditorInvoiceId", :bank_payment_creditor_invoice_id],
        ["CapitaliseHandle", :capitalise_handle, hash_with_number],
        ["StartDate", :start_date, nil, :required],
        ["EndDate", :end_date, nil, :required],
        ["EmployeeHandle", :employee_handle, hash_with_number]
      ]
    end
  end
end
