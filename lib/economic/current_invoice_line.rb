require 'economic/entity'
require 'economic/current_invoice'

module Economic

  # Represents a current invoice line.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICurrentInvoiceLine.html
  #
  # See Economic::CurrentInvoice for usage example
  class CurrentInvoiceLine < Entity
    has_properties :invoice_handle, :description, :delivery_date, :unit_handle, :product_handle, :quantity, :unit_net_price, :discount_as_percent, :unit_cost_price, :total_net_amount, :total_margin, :margin_as_percent

    def handle
      Handle.new(:number => number)
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

    def initialize_defaults
      self.invoice_handle = nil
      self.description = nil
      self.delivery_date = nil
      self.unit_handle = nil
      self.product_handle = nil
      self.quantity = nil
      self.unit_net_price = nil
      self.discount_as_percent = 0
      self.unit_cost_price = 0
      self.total_net_amount = nil
      self.total_margin = 0
      self.margin_as_percent = 0
    end

    # Returns OrderedHash with the properties of CurrentInvoice in the correct order, camelcased and ready
    # to be sent via SOAP
    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Number'] = 0 # Doesn't seem to be used
      data['InvoiceHandle'] = invoice.handle.to_hash unless invoice.blank?
      data['Description'] = description unless description.blank?
      data['DeliveryDate'] = delivery_date
      data['UnitHandle'] = { 'Number' => unit_handle[:number] } unless unit_handle.blank?
      data['ProductHandle'] = { 'Number' => product_handle[:number] } unless product_handle.blank?
      data['Quantity'] = quantity unless quantity.blank?
      data['UnitNetPrice'] = unit_net_price unless unit_net_price.blank?
      data['DiscountAsPercent'] = discount_as_percent unless discount_as_percent.blank?
      data['UnitCostPrice'] = unit_cost_price unless unit_cost_price.blank?
      data['TotalNetAmount'] = total_net_amount
      data['TotalMargin'] = total_margin unless total_margin.blank?
      data['MarginAsPercent'] = margin_as_percent unless margin_as_percent.blank?

      return data
    end
  end

end