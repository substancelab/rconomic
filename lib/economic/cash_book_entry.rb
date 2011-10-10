require 'economic/entity'

module Economic
  
  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBookEntry < Entity
    has_properties :account_handle, 
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
                   :cash_book_entry_type, 
                   :vat_account_handle, 
                   :voucher_number
    
    def initialize(properties = {})
      super
    end
    
    def initialize_defaults
      self.account_handle = nil
      self.amount = 0
      self.amount_default_currency = 0 
      self.bank_payment_creditor_id = 0
      self.bank_payment_creditor_invoice_id = 0 
      self.bank_payment_type_handle = nil
      self.capitalise_handle = nil
      self.cash_book_handle = nil
      self.contra_account_handle = nil
      self.contra_vat_account_handle = nil
      self.cost_type_handle = nil
      self.creditor_handle = nil
      self.creditor_invoice_number = nil
      self.currency_handle = nil
      self.date = Time.now
      self.debtor_handle = nil
      self.debtor_invoice_number = nil
      self.department_handle = nil
      self.distribution_key_handle = nil
      self.due_date = nil
      self.employee_handle = nil
      self.end_date = nil
      self.project_handle = nil
      self.start_date = Time.now
      self.text = ""
      self.cash_book_entry_type = ""
      self.vat_account_handle = nil
      self.voucher_number = 0
    end
    
    def handle
      Handle.new(:id => @id)
    end
    
    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Type'] = cash_book_entry_type
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
      #data['DebtorInvoiceNumber'] = debtor_invoice_number
      #data['CreditorInvoiceNumber'] = creditor_invoice_number
      data['DueDate'] = due_date
      data['DepartmentHandle'] = { 'Number' => department_handle[:number] } unless department_handle.blank? 
      data['DistributionKeyHandle'] = { 'Number' => distribution_key_handle[:number] } unless distribution_key_handle.blank?
      data['ProjectHandle'] = { 'Number' => project_handle[:number] } unless project_handle.blank?
      data['CostTypeHandle'] = { 'Number' => cost_type_handle[:number] } unless cost_type_handle.blank?
      data['BankPaymentTypeHandle'] = { 'Number' => bank_payment_type_handle[:number] } unless bank_payment_type_handle.blank?
      data['BankPaymentCreditorId'] = bank_payment_creditor_id
      data['BankPaymentCreditorInvoiceId'] = bank_payment_creditor_invoice_id
      data['CapitaliseHandle'] = { 'Number' => capitalise_handle[:number] } unless capitalise_handle.blank?
      data['StartDate'] = start_date
      data['EndDate'] = end_date
      data['EmployeeHandle'] = { 'Number' => employee_handle[:number] } unless employee_handle.blank?

      return data
    end
    
    def save
      result = super
      id = result[:id]
    end
  end
end