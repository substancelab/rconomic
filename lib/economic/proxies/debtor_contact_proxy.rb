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
    def find(id)
      # This is basically EntityProxy::find duplicated so we can pass id to the API instead of
      # Number...
      entity_hash = session.request entity_class.soap_action(:get_data)  do
        soap.body = {
          'entityHandle' => {
            'Id' => id
          }
        }
      end
      entity = build(entity_hash)
      entity.persisted = true
      entity
    end

  private

    # Initialize properties in contact with values from owner. Returns contact.
    def initialize_properties_with_values_from_owner(contact)
      contact.debtor_handle = owner.handle
      contact
    end

  end
end