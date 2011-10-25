require 'economic/proxies/entity_proxy'

module Economic
  class CurrentInvoiceProxy < EntityProxy
    def all
      entity_hash = session.request(entity_class.soap_action(:get_all))
      if entity_hash != {}
        [ entity_hash[:current_invoice_handle] ].flatten.each do |hash|
          id = hash.values.first
          find(id.to_i)
        end
      end
      self
    end

    # Returns a new, unpersisted Economic::CurrentInvoice
    def build(properties = {})
      invoice = super
      initialize_properties_with_values_from_owner(invoice) if owner.is_a?(Debtor)
      invoice
    end

    # Gets data for CurrentInvoice from the API
    def find(handle)
      handle = Entity::Handle.new(:id => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

  private

    # Initialize properties in invoice with values from owner
    def initialize_properties_with_values_from_owner(invoice)
      invoice.debtor = owner

      invoice.debtor_name         ||= owner.name
      invoice.debtor_address      ||= owner.address
      invoice.debtor_postal_code  ||= owner.postal_code
      invoice.debtor_city         ||= owner.city

      invoice.term_of_payment_handle  ||= owner.term_of_payment_handle
      invoice.layout_handle           ||= owner.layout_handle
      invoice.currency_handle         ||= owner.currency_handle

      invoice
    end

  end
end
