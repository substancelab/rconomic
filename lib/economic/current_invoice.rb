require "economic/entity"

module Economic
  # CurrentInvoices are invoices that are not yet booked. They are therefore not
  # read-only.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICurrentInvoice.html
  #
  # Examples
  #
  #   # Create invoice for debtor:
  #   invoice = debtor.current_invoices.build
  #   invoice.date = Time.now
  #   invoice.due_date = Time.now + 15
  #   invoice.exchange_rate = 100
  #   invoice.is_vat_included = false
  #
  #   # Add a line to the invoice
  #   invoice_line = invoice.lines.build
  #   invoice_line.description = 'Line on invoice'
  #   invoice_line.unit_handle = { :number => 1 }
  #   invoice_line.product_handle = { :number => 101 }
  #   invoice_line.quantity = 12
  #   invoice_line.unit_net_price = 19.95
  #   invoice.lines << invoice_line
  #
  #   invoice.save
  class CurrentInvoice < Entity
    property(:id, :required => true, :default => 0)
    property(:debtor_handle, :formatter => Properties::Formatters::HANDLE)
    property(:debtor_name, :required => true)
    property(:debtor_address)
    property(:debtor_postal_code)
    property(:debtor_city)
    property(:debtor_country)
    property(:attention_handle, :formatter => Properties::Formatters::HANDLE)
    property(:date, :formatter => Properties::Formatters::DATE, :default => Time.now)
    property(:term_of_payment_handle, :formatter => Properties::Formatters::HANDLE)
    property(:due_date, :formatter => Properties::Formatters::DATE, :required => true)
    property(:currency_handle, :formatter => Properties::Formatters::HANDLE)
    property(:exchange_rate, :default => 100)
    property(:is_vat_included, :required => true)
    property(:layout_handle, :formatter => Properties::Formatters::HANDLE)
    property(:delivery_date, :formatter => Properties::Formatters::DATE, :required => true)
    property(:heading)
    property(:text_line1)
    property(:text_line2)
    property(:net_amount, :required => true, :default => 0)
    property(:vat_amount, :required => true, :default => 0)
    property(:gross_amount, :required => true, :default => 0)
    property(:margin, :required => true, :default => 0)
    property(:margin_as_percent, :required => true, :default => 0)

    def initialize(properties = {})
      super
    end

    def attention
      return nil if attention_handle.nil?
      @attention ||= session.contacts.find(attention_handle)
    end

    def attention=(contact)
      self.attention_handle = contact.handle
      @attention = contact
    end

    def attention_handle=(handle)
      @attention = nil unless handle == @attention_handle
      @attention_handle = handle
    end

    # Books a current invoice. An invoice number greater than all other invoice
    # numbers will be assigned to the resulting Economic::Invoice.
    #
    # Returns the resulting Economic::Invoice object
    def book
      response = request(:book, "currentInvoiceHandle" => handle.to_hash)

      # Find the created Invoice
      session.invoices.find(response[:number])
    end

    # Books a current invoice. The given number will be assigned to the
    # resulting Economic::Invoice.
    #
    # Returns the resulting Economic::Invoice object
    def book_with_number(number)
      response = request(
        :book_with_number,
        "currentInvoiceHandle" => handle.to_hash,
        "number" => number
      )

      # Find the created Invoice
      session.invoices.find(response[:number])
    end

    def debtor
      return nil if debtor_handle.nil?
      @debtor ||= session.debtors.find(debtor_handle)
    end

    def debtor=(debtor)
      self.debtor_handle = debtor.handle
      @debtor = debtor
    end

    def debtor_handle=(handle)
      @debtor = nil unless handle == @debtor_handle
      @debtor_handle = handle
    end

    def handle
      @handle || Handle.new(:id => @id)
    end

    def lines
      @lines ||= CurrentInvoiceLineProxy.new(self)
    end

    def save
      lines = self.lines

      result = super
      self.id = result[:id].to_i

      lines.each do |invoice_line|
        invoice_line.session = session
        invoice_line.invoice = self
        invoice_line.save
      end
    end
  end
end
