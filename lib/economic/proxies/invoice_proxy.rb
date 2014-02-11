require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_date_interval'
require 'economic/proxies/actions/find_by_handle_with_number'

module Economic
  class InvoiceProxy < EntityProxy
    include FindByDateInterval
    include FindByHandleWithNumber
  end
end
