module Economic
  class CurrentInvoiceProxy
    attr_reader :owner

    def initialize(owner)
      @owner = owner
    end

    def session
      owner.session
    end

    # Returns a new, unpersisted Economic::CurrentInvoice
    def build(properties = {})
      invoice = Economic::CurrentInvoice.new(:session => session)

      initialize_properties_with_values_from_owner(invoice) if owner.is_a?(Debtor)
      invoice.update_properties(properties)
      invoice.partial = false

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