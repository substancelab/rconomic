require 'economic/entity'

module Economic

  # Current invoices are invoices that are not yet booked. They are therefore not read-only.
  #
  # http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICurrentInvoice.html
  class CurrentInvoice < Entity
    has_properties :id, :debtor_handle, :debtor_name, :debtor_address, :debtor_postal_code, :debtor_city, :debtor_country, :date, :term_of_payment_handle, :due_date, :currency_handle, :exchange_rate, :is_vat_included, :layout_handle, :delivery_date, :net_amount, :vat_amount, :gross_amount, :margin, :margin_as_percent

    def initialize(properties = {})
      super
    end

    # Returns the current invoice lines of CurrentInvoice
    def lines
      @lines ||= CurrentInvoiceLineProxy.new(self)
    end

    def initialize_defaults
      self.id = 0
      self.date = Time.now
      self.term_of_payment_handle = nil
      self.due_date = nil
      self.currency_handle = nil
      self.exchange_rate = 100 # Why am _I_ inputting this?
      self.is_vat_included = nil
      self.layout_handle = nil
      self.delivery_date = nil
      self.net_amount = 0
      self.vat_amount = 0
      self.gross_amount = 0
      self.margin = 0
      self.margin_as_percent = 0 # Why do I have to input both Margin and MarginAsPercent? Shouldn't powerful Windows machines running ASP.NET be able to compute this?
    end

    # Returns OrderedHash with the properties of CurrentInvoice in the correct order, camelcased and ready
    # to be sent via SOAP
    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Id'] = id
      data['DebtorHandle'] = { 'Number' => debtor_handle[:number] } unless debtor_handle.blank?
      data['DebtorName'] = debtor_name
      data['DebtorAddress'] = debtor_address unless debtor_address.blank?
      data['DebtorPostalCode'] = debtor_postal_code unless debtor_postal_code.blank?
      data['DebtorCity'] = debtor_city unless debtor_city.blank?
      data['DebtorCountry'] = debtor_country unless debtor_country.blank?
      data['Date'] = date.iso8601 unless date.blank?
      data['TermOfPaymentHandle'] = { 'Id' => term_of_payment_handle[:id] } unless term_of_payment_handle.blank?
      data['DueDate'] = due_date.iso8601 unless due_date.blank?
      data['CurrencyHandle'] = { 'Code' => currency_handle[:code] } unless currency_handle.blank?
      data['ExchangeRate'] = exchange_rate
      data['IsVatIncluded'] = is_vat_included
      data['LayoutHandle'] = { 'Id' => layout_handle[:id] } unless layout_handle.blank?
      data['DeliveryDate'] = delivery_date ? delivery_date.iso8601 : nil
      data['NetAmount'] = net_amount
      data['VatAmount'] = vat_amount
      data['GrossAmount'] = gross_amount
      data['Margin'] = margin
      data['MarginAsPercent'] = margin_as_percent

      return data
    end

    def save
      result = super
      id = result[:id]

      self.lines.each do |invoice_line|
        invoice_line.session = session
        invoice_line.invoice_handle = { :id => id }
        invoice_line.save
      end
    end
  end

end