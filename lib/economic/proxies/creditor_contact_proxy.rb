require 'economic/proxies/entity_proxy'

module Economic
  class CreditorContactProxy < EntityProxy

    # Returns a new, unpersisted Economic::CreditorContact
    def build(properties = {})
      contact = super
      initialize_properties_with_values_from_owner(contact) if owner.is_a?(Creditor)
      contact
    end

    # Gets data for CreditorContact from the API
    def find(handle)
      handle = Entity::Handle.build(:id => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

    # Returns CreditorContact that have the given name. The objects will only be partially loaded
    def find_by_name(name)
      # Get a list of CreditorContactHandles from e-conomic
      response = request('FindByName', {
       'name' => name
      })

      # Make sure we always have an array of handles even if the result only contains one
      handles = [response[:creditor_contact_handle]].flatten.reject(&:blank?)

      # Create partial CreditorContact entities
      contacts = handles.collect do |handle|
        creditor_contact = build
        creditor_contact.partial = true
        creditor_contact.persisted = true
        creditor_contact.handle = handle
        creditor_contact.id = handle[:id]
        creditor_contact.number = handle[:number]
        creditor_contact
      end

      if owner.is_a?(Creditor)
        # Scope to the owner
        contacts.select do |creditor_contact|
          creditor_contact.get_data
          creditor_contact.creditor.handle == owner.handle
        end
      else
        contacts
      end

    end


  private

    # Initialize properties in contact with values from owner. Returns contact.
    def initialize_properties_with_values_from_owner(contact)
      contact.creditor = owner
      contact
    end

  end
end
