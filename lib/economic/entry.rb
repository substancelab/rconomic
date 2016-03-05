require "economic/entity"

module Economic
  # Represents an entry in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IEntry.html

  class Entry < Entity
    has_properties :serial_number,
      :account_handle,
      :amount,
      :amount_default_currency,
      :currency_handle,
      :date,
      :text,
      :type,
      :department_handle,
      :distribution_key_handle,
      :vat_account_handle,
      :voucher_number,
      :project_handle,
      :document_handle
  end
end
