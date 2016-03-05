require "economic/entity"

module Economic
  # Represents a creditor entry in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICreditorEntry.html
  class CreditorEntry < Entity
    has_properties :account,
      :amount,
      :amount_default_currency,
      :creditor,
      :currency,
      :date,
      :due_date,
      :invoice_number,
      :remainder,
      :remainder_default_currency,
      :serial_number,
      :text,
      :type,
      :voucher_number
  end
end
