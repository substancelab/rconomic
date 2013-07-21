require 'economic/entity'

module Economic

  # Represents a debtor in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtor.html
  #
  # Examples
  #
  #   # Find a debtor:
  #   debtor = economic.debtors.find(558)
  #
  #   # Creating a debtor:
  #   debtor = economic.debtors.build
  #   debtor.number = economic.debtors.next_available_number
  #   debtor.debtor_group_handle = { :number => 1 }
  #   debtor.name = 'Apple Inc'
  #   debtor.vat_zone = 'HomeCountry' # HomeCountry, EU, Abroad
  #   debtor.currency_handle = { :code => 'DKK' }
  #   debtor.price_group_handle = { :number => 1 }
  #   debtor.is_accessible = true
  #   debtor.ci_number = '12345678'
  #   debtor.term_of_payment_handle = { :id => 1 }
  #   debtor.layout_handle = { :id => 16 }
  #   debtor.save
  class Debtor < Entity
    has_properties :number, :debtor_group_handle, :name, :vat_zone, :currency_handle, :price_group_handle, :is_accessible, :ean, :public_entry_number, :email, :telephone_and_fax_number, :website, :address, :postal_code, :city, :country, :credit_maximum, :vat_number, :county, :ci_number, :term_of_payment_handle, :layout_handle, :attention_handle, :your_reference_handle, :our_reference_handle, :balance

    def handle
      @handle ||= Handle.new({:number => @number})
    end

    # Returns the Debtors contacts
    def contacts
      @contacts ||= DebtorContactProxy.new(self)
    end

    # Provides access to the current invoices for Debtor - ie invoices that haven't yet been booked
    def current_invoices
      @current_invoices ||= CurrentInvoiceProxy.new(self)
    end

    protected

    def build_soap_data
      data = {}

      data['Handle'] = handle.to_hash
      data['Number'] = handle.number
      data['DebtorGroupHandle'] = { 'Number' => debtor_group_handle[:number] } unless debtor_group_handle.blank?
      data['Name'] = name
      data['VatZone'] = vat_zone
      data['CurrencyHandle'] = { 'Code' => currency_handle[:code] } unless currency_handle.blank?
      data['PriceGroupHandle'] = { 'Number' => price_group_handle[:number] } unless price_group_handle.blank?
      data['IsAccessible'] = is_accessible
      data['Ean'] = ean unless ean.blank?
      data['PublicEntryNumber'] = public_entry_number unless public_entry_number.blank?
      data['Email'] = email unless email.blank?
      data['TelephoneAndFaxNumber'] = telephone_and_fax_number unless telephone_and_fax_number.blank?
      data['Website'] = website unless website.blank?
      data['Address'] = address unless address.blank?
      data['PostalCode'] = postal_code unless postal_code.blank?
      data['City'] = city unless city.blank?
      data['Country'] = country unless country.blank?
      data['CreditMaximum'] = credit_maximum unless credit_maximum.blank?
      data['VatNumber'] = vat_number unless vat_number.blank?
      data['County'] = county unless county.blank?
      data['CINumber'] = ci_number unless ci_number.blank?
      data['TermOfPaymentHandle'] = { 'Id' => term_of_payment_handle[:id] } unless term_of_payment_handle.blank?
      data['LayoutHandle'] = { 'Id' => layout_handle[:id] } unless layout_handle.blank?
      data['AttentionHandle'] = attention_handle unless attention_handle.blank?
      data['YourReferenceHandle'] = your_reference_handle unless your_reference_handle.blank?
      data['OurReferenceHandle'] = our_reference_handle unless our_reference_handle.blank?
      data['Balance'] = balance unless balance.blank?

      return data
    end

  end

end
