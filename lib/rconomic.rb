# Dependencies
require "time"
require "savon"

require "economic/support/string"
require "economic/session"

require "economic/debtor"
require "economic/debtor_contact"
require "economic/creditor"
require "economic/creditor_contact"
require "economic/current_invoice"
require "economic/current_invoice_line"
require "economic/invoice"
require "economic/order"
require "economic/cash_book"
require "economic/cash_book_entry"
require "economic/account"
require "economic/debtor_entry"
require "economic/creditor_entry"
require "economic/entry"
require "economic/product"
require "economic/company"

require "economic/proxies/current_invoice_proxy"
require "economic/proxies/current_invoice_line_proxy"
require "economic/proxies/debtor_proxy"
require "economic/proxies/debtor_contact_proxy"
require "economic/proxies/creditor_proxy"
require "economic/proxies/creditor_contact_proxy"
require "economic/proxies/invoice_proxy"
require "economic/proxies/order_proxy"
require "economic/proxies/cash_book_proxy"
require "economic/proxies/cash_book_entry_proxy"
require "economic/proxies/account_proxy"
require "economic/proxies/debtor_entry_proxy"
require "economic/proxies/creditor_entry_proxy"
require "economic/proxies/entry_proxy"
require "economic/proxies/product_proxy"
require "economic/proxies/company_proxy"

require "economic/proxies/actions/debtor_contact/all"
require "economic/proxies/actions/find_by_name"

# http://www.e-conomic.com/apidocs/Documentation/index.html
# https://www.e-conomic.com/secure/api1/EconomicWebService.asmx
#
# TODO
#
# * Basic validations; ie check for nil values before submitting to API

module Economic
end
