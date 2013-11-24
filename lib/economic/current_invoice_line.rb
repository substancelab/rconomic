require 'economic/entity'
require 'economic/current_invoice'

module Economic

  # Represents a current invoice line.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICurrentInvoiceLine.html
  #
  # See Economic::CurrentInvoice for usage example
  class CurrentInvoiceLine < Entity
    has_properties :number,
      :invoice_handle,
      :description,
      :delivery_date,
      :unit_handle,
      :product_handle,
      :quantity,
      :unit_net_price,
      :discount_as_percent,
      :unit_cost_price,
      :total_net_amount,
      :total_margin,
      :margin_as_percent

    defaults(
      :invoice_handle => nil,
      :description => nil,
      :delivery_date => nil,
      :unit_handle => nil,
      :product_handle => nil,
      :quantity => nil,
      :unit_net_price => nil,
      :discount_as_percent => 0,
      :unit_cost_price => 0,
      :total_net_amount => nil,
      :total_margin => 0,
      :margin_as_percent => 0
    )

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

    protected

    def fields
      to_hash = Proc.new { |h| h.to_hash }
      [
        ["Number", :number, Proc.new { 0 }, :required], # Doesn't seem to be used
        ["InvoiceHandle", :invoice_handle, to_hash],
        ["Description", :description],
        ["DeliveryDate", :delivery_date, nil, :required],
        ["UnitHandle", :unit_handle, to_hash],
        ["ProductHandle", :product_handle, to_hash],
        ["Quantity", :quantity],
        ["UnitNetPrice", :unit_net_price],
        ["DiscountAsPercent", :discount_as_percent],
        ["UnitCostPrice", :unit_cost_price],
        ["TotalNetAmount", :total_net_amount, nil, :required],
        ["TotalMargin", :total_margin],
        ["MarginAsPercent", :margin_as_percent]
      ]
    end
  end
end
