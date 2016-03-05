require "economic/entity"

module Economic
  # Represents a debtor entry in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtorEntry.html

  class DebtorEntry < Entity
    has_properties :serial_number,
      :type,
      :date,
      :debtor_handle,
      :account_handle,
      :voucher_number,
      :text,
      :amount_default_currency,
      :currency_handle,
      :amount,
      :invoice_number,
      :due_date,
      :remainder,
      :remainder_default_currency
  end
end
