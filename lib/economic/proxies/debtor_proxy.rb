require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_number'
require 'economic/proxies/actions/find_by_ci_number'

module Economic
  class DebtorProxy < EntityProxy
    include FindByNumber
    include FindByCiNumber

    # Fetches Debtor from API
    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:number => handle.to_i)
      else
        Entity::Handle.new(handle)
      end
      super(handle)
    end

    # Returns the next available debtor number
    def next_available_number
      session.request Debtor.soap_action(:get_next_available_number)
    end
  end
end
