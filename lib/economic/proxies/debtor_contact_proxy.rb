require "economic/proxies/entity_proxy"

module Economic
  class DebtorContactProxy < EntityProxy
    # Returns DebtorContact that have the given name. The objects will only be
    # partially loaded
    def find_by_name(name)
      Proxies::Actions::FindByName.new(self, name).call
    end

    def all
      Proxies::Actions::DebtorContact::All.new(self).call
    end

    private

    # Initialize properties in contact with values from owner. Returns contact.
    def initialize_properties_with_values_from_owner(contact)
      if owner.is_a?(Debtor)
        contact.debtor = owner
      end
      contact
    end
  end
end
