# Usage example
#
# economic = Economic::Session.new(123456, 'API', 'passw0rd')
# economic.connect
# 
# # Find a debtor:
# debtor = economic.debtors.find(204)
#
# Creating a debtor:
# debtor = economic.debtors.build
#
# debtor.number = economic.debtors.next_available_number
# debtor.debtor_group_handle = { number => 1 }
# debtor.name = 'Bob'
# debtor.vat_zone = 'HomeCountry' # HomeCountry, EU, Abroad
# debtor.currency = 'DKK'
# debtor.price_group = 1
# debtor.is_accessible = true
# debtor.ci_number = '12345678'
# debtor.term_of_payment_handle = { :id => 1 }
# debtor.layout_handle = { :id => 16 }
# debtor.save
#
# Create invoice for debtor:
#
# invoice = Economic::CurrentInvoice.new
# invoice.session = economic
#
# invoice.debtor_handle = { :number => debtor.number }
# invoice.debtor_name = 'Bob'
# invoice.date = Time.now
# invoice.due_date = Time.now + 15
# invoice.term_of_payment_handle = { :id => 1 }
#
# invoice.currency_handle = { :code => 'DKK' }
# invoice.exchange_rate = 100
# invoice.is_vat_included = false
# invoice.layout_handle = { :id => 16 }
#
# invoice_line = Economic::CurrentInvoiceLine.new
# invoice_line.description = 'Line on invoice'
# invoice_line.unit_handle = { :number => 1 }
# invoice_line.product_handle = { :number => 101 }
# invoice_line.quantity = 12
# invoice_line.unit_net_price = 19.95
# invoice.lines << invoice_line
#
# invoice.save

# Dependencies
require 'time'
require 'savon'
require 'active_support/ordered_hash'

require 'economic/session'
require 'economic/debtor'
require 'economic/current_invoice'
require 'economic/current_invoice_line'
require 'economic/debtor_proxy'

# http://www.e-conomic.com/apidocs/Documentation/index.html
# https://www.e-conomic.com/secure/api1/EconomicWebService.asmx
#
# TODO
#
# * Memoization via ActiveSupport?
# * Basic validations; ie check for nil values before submitting to API
# * Better Handle handling

module Economic
end

