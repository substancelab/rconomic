require "economic/entity"
require "economic/current_invoice"

module Economic
  # Represents a current invoice line.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICurrentInvoiceLine.html
  #
  # See Economic::CurrentInvoice for usage example
  class CurrentInvoiceLine < Entity
    property(:number, :formatter => proc { 0 }, :required => true)
    property(:invoice_handle, :formatter => proc { |h| h.to_hash })
    property(:description)
    property(:delivery_date, :required => true)
    property(:unit_handle, :formatter => proc { |h| h.to_hash })
    property(:product_handle, :formatter => proc { |h| h.to_hash })
    property(:quantity)
    property(:unit_net_price)
    property(:discount_as_percent, :default => 0)
    property(:unit_cost_price, :default => 0)
    property(:total_net_amount, :required => true)
    property(:total_margin, :default => 0)
    property(:margin_as_percent, :default => 0)

    def handle
      @handle || Handle.build(:number => number)
    end

    def invoice
      return nil if invoice_handle.blank?
      @invoice ||= session.current_invoices.find(invoice_handle)
    end

    def invoice=(invoice)
      self.invoice_handle = invoice.handle
      @invoice = invoice
    end

    def invoice_handle=(handle)
      @invoice = nil unless handle == @invoice_handle
      @invoice_handle = handle
    end
  end
end
