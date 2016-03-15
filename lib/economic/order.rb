require "economic/entity"

module Economic

  # Order is almost like a CurrentInvoice, except you can not book it.
  # It's writeable like an CurrentInvoice. See CurrentInvoice example, too see how it works.
  # Use the same approch, and properties.

  class Order < Entity
    has_properties :id,
      :number,
      :debtor_handle,
      :debtor_name,
      :debtor_address,
      :debtor_postal_code,
      :debtor_city,
      :debtor_country,
      :is_archived,
      :is_sent,
      :attention_handle,
      :your_reference_handle,
      :our_reference_handle,
      :other_reference,
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
      :heading,
      :text_line1,
      :text_line2,
      :rounding_amount

    defaults(
      :id => nil,
      :number => 0,
      :date => Time.now,
      :is_archived => false,
      :is_sent => false,
      :term_of_payment_handle => nil,
      :due_date => nil,
      :currency_handle => nil,
      :your_reference_handle => nil,
      :our_reference_handle => nil,
      :other_reference => nil,
      :exchange_rate => 100, # Why am _I_ inputting this?
      :is_vat_included => nil,
      :layout_handle => nil,
      :delivery_date => nil,
      :heading => nil,
      :net_amount => 0,
      :vat_amount => 0,
      :gross_amount => 0,
      :rounding_amount => 0,
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
      @lines ||= OrderLineProxy.new(self)
    end

    def save
      lines = self.lines

      result = super
      self.id = result[:id].to_i

      lines.each do |order_line|
        order_line.session = session
        order_line.order = self
        order_line.save
      end
    end

    def pdf
      response = request(:get_pdf, {
                           "orderHandle" => handle.to_hash
      })
      Base64.decode64(response)
    end

    protected

    def fields
      date_formatter = Proc.new { |date| date.respond_to?(:iso8601) ? date.iso8601 : nil }
      to_hash = Proc.new { |handle| handle.to_hash }
      [
        ["Id", :id],
        ["Number", :number, nil, :required],
        ["DebtorHandle", :debtor, Proc.new { |d| d.handle.to_hash }],
        ["DebtorName", :debtor_name, nil, :required],
        ["DebtorAddress", :debtor_address],
        ["DebtorPostalCode", :debtor_postal_code],
        ["DebtorCity", :debtor_city],
        ["DebtorCountry", :debtor_country],
        ["AttentionHandle", :attention_handle, to_hash],
        ["YourReferenceHandle", :your_reference_handle, to_hash],
        ["OurReferenceHandle", :our_reference_handle, to_hash],
        ["OtherReference", :other_reference],
        ["Date", :date, date_formatter],
        ["TermOfPaymentHandle", :term_of_payment_handle, to_hash],
        ["DueDate", :due_date, date_formatter, :required],
        ["CurrencyHandle", :currency_handle, to_hash],
        ["ExchangeRate", :exchange_rate],
        ["IsVatIncluded", :is_vat_included, nil, :required],
        ["LayoutHandle", :layout_handle, to_hash],
        ["DeliveryDate", :delivery_date, date_formatter, :required],
        ["Heading", :heading],
        ['TextLine1', :text_line1],
        ['TextLine2', :text_line2],
        ["NetAmount", :net_amount, nil, :required],
        ["VatAmount", :vat_amount, nil, :required],
        ["GrossAmount", :gross_amount, nil, :required],
        ["Margin", :margin, nil, :required],
        ["MarginAsPercent", :margin_as_percent, nil, :required],
        ["IsArchived", :is_archived, nil, :required],
        ["IsSent", :is_sent, nil, :required],
        ["RoundingAmount", :rounding_amount, nil]
      ]
    end
  end
end
