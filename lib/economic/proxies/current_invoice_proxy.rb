require 'economic/proxies/entity_proxy'

module Economic
  class CurrentInvoiceProxy < EntityProxy
    class << self
      # Returns the class this proxy is a proxy for
      def entity_class
        CurrentInvoice
      end
    end

    # Returns a new, unpersisted Economic::CurrentInvoice
    def build(properties = {})
      invoice = super
      initialize_properties_with_values_from_owner(invoice) if owner.is_a?(Debtor)
      invoice
    end

  private

    # Initialize properties in invoice with values from owner
    def initialize_properties_with_values_from_owner(invoice)
      invoice.debtor_handle = owner.handle

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