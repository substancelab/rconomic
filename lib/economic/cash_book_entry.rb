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
      Handle.new(:id1 => @id1, :id2 => @id2)
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash unless handle.to_hash.empty?
      data['Id1'] = id1 unless id1.blank?
      data['Id2'] = id2 unless id2.blank?
      data['Type'] = type unless type.blank?
      data['CashBookHandle'] = { 'Number' => cash_book_handle[:number] } unless cash_book_handle.blank?
      data['DebtorHandle'] = { 'Number' => debtor_handle[:number] } unless debtor_handle.blank?
      data['CreditorHandle'] = { 'Number' => creditor_handle[:number] } unless creditor_handle.blank?
      data['AccountHandle'] = { 'Number' => account_handle[:number] } unless account_handle.blank?
      data['ContraAccountHandle'] = { 'Number' => contra_account_handle[:number] } unless contra_account_handle.blank?
      data['Date'] = date
      data['VoucherNumber'] = voucher_number
      data['Text'] = text
      data['AmountDefaultCurrency'] = amount_default_currency
      data['CurrencyHandle'] = { 'Code' => currency_handle[:code] } unless currency_handle.blank?
      data['Amount'] = amount
      data['VatAccountHandle'] = { 'Number' => vat_account_handle[:number] } unless vat_account_handle.blank?
      data['ContraVatAccountHandle'] = { 'Number' => contra_vat_account_handle[:number] } unless contra_vat_account_handle.blank?
      data['DebtorInvoiceNumber'] = debtor_invoice_number unless debtor_invoice_number.blank?
      data['CreditorInvoiceNumber'] = creditor_invoice_number unless creditor_invoice_number.blank?
      data['DueDate'] = due_date
      data['DepartmentHandle'] = { 'Number' => department_handle[:number] } unless department_handle.blank?
      data['DistributionKeyHandle'] = { 'Number' => distribution_key_handle[:number] } unless distribution_key_handle.blank?
      data['ProjectHandle'] = { 'Number' => project_handle[:number] } unless project_handle.blank?
      data['CostTypeHandle'] = { 'Number' => cost_type_handle[:number] } unless cost_type_handle.blank?
      data['BankPaymentTypeHandle'] = { 'Number' => bank_payment_type_handle[:number] } unless bank_payment_type_handle.blank?
      data['BankPaymentCreditorId'] = bank_payment_creditor_id unless bank_payment_creditor_id.blank?
      data['BankPaymentCreditorInvoiceId'] = bank_payment_creditor_invoice_id unless bank_payment_creditor_invoice_id.blank?
      data['CapitaliseHandle'] = { 'Number' => capitalise_handle[:number] } unless capitalise_handle.blank?
      data['StartDate'] = start_date
      data['EndDate'] = end_date
      data['EmployeeHandle'] = { 'Number' => employee_handle[:number] } unless employee_handle.blank?

      return data
    end
  end
end
