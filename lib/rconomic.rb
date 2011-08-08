# Dependencies
require 'time'
require 'savon'
require 'active_support/ordered_hash'

require 'economic/session'
require 'economic/debtor'
require 'economic/debtor_contact'
require 'economic/current_invoice'
require 'economic/current_invoice_line'

require 'economic/proxies/current_invoice_proxy'
require 'economic/proxies/current_invoice_line_proxy'
require 'economic/proxies/debtor_proxy'
require 'economic/proxies/debtor_contact_proxy'

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

