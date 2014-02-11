require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_ci_number'
require 'economic/proxies/actions/find_by_handle_with_number'
require 'economic/proxies/actions/find_by_number'
require 'economic/proxies/actions/find_by_telephone_and_fax_number'

module Economic
  class DebtorProxy < EntityProxy
    include FindByCiNumber
    include FindByHandleWithNumber
    include FindByNumber
    include FindByTelephoneAndFaxNumber

    # Returns the next available debtor number
    def next_available_number
      request :get_next_available_number
    end
  end
end
