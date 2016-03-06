require "economic/entity"

module Economic
  # Represents a creditor entry in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICreditorEntry.html
  class CreditorEntry < Entity
    property(:account)
    property(:amount)
    property(:amount_default_currency)
    property(:creditor)
    property(:currency)
    property(:date)
    property(:due_date)
    property(:invoice_number)
    property(:remainder)
    property(:remainder_default_currency)
    property(:serial_number)
    property(:text)
    property(:type)
    property(:voucher_number)
  end
end
