require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_ci_number'
require 'economic/proxies/actions/find_by_handle_with_number'
require 'economic/proxies/actions/find_by_number'

module Economic
  class CreditorProxy < EntityProxy
    include FindByCiNumber
    include FindByHandleWithNumber
    include FindByNumber

    def create_simple(opts)
      response = session.request(entity_class.soap_action_name('Create')) do
        soap.body = {
          'number' => opts[:number],
          'creditorGroupHandle' => { 'Number' => opts[:creditor_group_handle][:number] },
          :name => opts[:name],
          :vatZone => opts[:vat_zone]
        }
      end

      find(response)
    end

  end
end
