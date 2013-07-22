require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/debtor_contact_proxy/find_by_name'

module Economic
  class DebtorContactProxy < EntityProxy

    # Returns a new, unpersisted Economic::DebtorContact
    def build(properties = {})
      contact = super
      initialize_properties_with_values_from_owner(contact) if owner.is_a?(Debtor)
      contact
    end

    # Gets data for DebtorContact from the API
    def find(handle)
      handle = Entity::Handle.build(:id => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

    # Returns DebtorContact that have the given name. The objects will only be
    # partially loaded
    def find_by_name(name)
      Proxies::Actions::DebtorContactProxy::FindByName.new(self, name).call
    end

  private

    # Initialize properties in contact with values from owner. Returns contact.
    def initialize_properties_with_values_from_owner(contact)
      contact.debtor = owner
      contact
    end

  end
end
