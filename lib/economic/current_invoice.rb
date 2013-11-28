require 'economic/entity'

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
    has_properties :id,
      :debtor_handle,
      :debtor_name,
      :debtor_address,
      :debtor_postal_code,
      :debtor_city,
      :debtor_country,
      :attention_handle,
      :date,
      :term_of_payment_handle,
      :due_date,
      :currency_handle,
      :exchange_rate,
      :is_vat_included,
      :layout_handle,
      :delivery_date,
      :net_amount,
      :vat_amount,
      :gross_amount,
      :margin,
      :margin_as_percent,
      :heading

    defaults(
      :id => 0,
      :date => Time.now,
      :term_of_payment_handle => nil,
      :due_date => nil,
      :currency_handle => nil,
      :exchange_rate => 100, # Why am _I_ inputting this?
      :is_vat_included => nil,
      :layout_handle => nil,
      :delivery_date => nil,
      :heading => nil,
      :net_amount => 0,
      :vat_amount => 0,
      :gross_amount => 0,
      :margin => 0,
      :margin_as_percent => 0 # Why do I have to input both Margin and MarginAsPercent? Shouldn't powerful Windows machines running ASP.NET be able to compute this?
    )

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
      response = request(:book, {
        "currentInvoiceHandle" => handle.to_hash
      })

      # Find the created Invoice
      session.invoices.find(response[:number])
    end

    # Books a current invoice. The given number will be assigned to the
    # resulting Economic::Invoice.
    #
    # Returns the resulting Economic::Invoice object
    def book_with_number(number)
      response = request(:book_with_number, {
        "currentInvoiceHandle" => handle.to_hash,
        "number" => number
      })

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

    protected

    def fields
      date_formatter = Proc.new { |date| date.respond_to?(:iso8601) ? date.iso8601 : nil }
      to_hash = Proc.new { |handle| handle.to_hash }
      [
        ["Id", :id, nil, :required],
        ["DebtorHandle", :debtor, Proc.new { |d| d.handle.to_hash }],
        ["DebtorName", :debtor_name, nil, :required],
        ["DebtorAddress", :debtor_address],
        ["DebtorPostalCode", :debtor_postal_code],
        ["DebtorCity", :debtor_city],
        ["DebtorCountry", :debtor_country],
        ["AttentionHandle", :attention_handle, to_hash],
        ["Date", :date, date_formatter],
        ["TermOfPaymentHandle", :term_of_payment_handle, to_hash],
        ["DueDate", :due_date, date_formatter, :required],
        ["CurrencyHandle", :currency_handle, to_hash],
        ["ExchangeRate", :exchange_rate],
        ["IsVatIncluded", :is_vat_included, nil, :required],
        ["LayoutHandle", :layout_handle, to_hash],
        ["DeliveryDate", :delivery_date, date_formatter, :required],
        ["Heading", :heading],
        ["NetAmount", :net_amount, nil, :required],
        ["VatAmount", :vat_amount, nil, :required],
        ["GrossAmount", :gross_amount, nil, :required],
        ["Margin", :margin, nil, :required],
        ["MarginAsPercent", :margin_as_percent, nil, :required]
      ]
    end
  end
end
