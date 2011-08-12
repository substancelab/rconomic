require 'economic/proxies/entity_proxy'

module Economic
  class CurrentInvoiceLineProxy < EntityProxy
    # Returns a new, unpersisted Economic::CurrentInvoiceLine
    def build(properties = {})
      invoice_line = super
      initialize_properties_with_values_from_owner(invoice_line) if owner.is_a?(CurrentInvoice)
      self.append(invoice_line)
      invoice_line
    end

  private

    # Initialize properties in invoice_line with values from owner
    def initialize_properties_with_values_from_owner(invoice_line)
      invoice_line.invoice = owner
      invoice_line
    end

  end
end