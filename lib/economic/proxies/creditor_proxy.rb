require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_number'
require 'economic/proxies/actions/find_by_ci_number'

module Economic
  class CreditorProxy < EntityProxy
    include FindByNumber
    include FindByCiNumber

    # Fetches Creditor from API
    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:number => handle.to_i)
      else
        Entity::Handle.new(handle)
      end
      super(handle)
    end

    def create_simple(opts)
      response = session.request(entity_class.soap_action('Create')) do
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
