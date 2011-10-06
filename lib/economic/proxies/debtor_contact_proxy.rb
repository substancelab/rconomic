require 'economic/proxies/entity_proxy'

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
      handle = Entity::Handle.new(:id => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

    # Returns DebtorContact that have the given name. The objects will only be partially loaded
    def find_by_name(name)
      # Get a list of DebtorContactHandles from e-conomic
      response = session.request entity_class.soap_action('FindByName') do
        soap.body = {
          'name' => name
        }
      end

      # Make sure we always have an array of handles even if the result only contains one
      handles = [response[:debtor_contact_handle]].flatten.reject(&:blank?)

      # Create partial DebtorContact entities
      contacts = handles.collect do |handle|
        debtor_contact = build
        debtor_contact.partial = true
        debtor_contact.persisted = true
        debtor_contact.handle = handle
        debtor_contact.id = handle[:id]
        debtor_contact.number = handle[:number]
        debtor_contact
      end

      if owner.is_a?(Debtor)
        # Scope to the owner
        contacts.select do |debtor_contact|
          debtor_contact.get_data
          debtor_contact.debtor.handle == owner.handle
        end
      else
        contacts
      end

    end


  private

    # Initialize properties in contact with values from owner. Returns contact.
    def initialize_properties_with_values_from_owner(contact)
      contact.debtor = owner
      contact
    end

  end
end