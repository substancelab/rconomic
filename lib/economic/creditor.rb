require 'economic/entity'

module Economic

  # Represents a creditor in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICreditor.html
  #
  # Examples
  #
  #   # Find a creditor:
  #   creditor = economic.creditors.find(558)
  #
  #   # Creating a creditor:
  #   creditor = economic.creditors.build
  #   creditor.number = economic.creditors.next_available_number
  #   creditor.creditor_group_handle = { :number => 1 }
  #   creditor.name = 'Apple Inc'
  #   creditor.vat_zone = 'HomeCountry' # HomeCountry, EU, Abroad
  #   creditor.is_accessible = true
  #   creditor.ci_number = '12345678'
  #   creditor.term_of_payment = 1
  #   creditor.save
  class Creditor < Entity
    has_properties :number, :creditor_group_handle, :name, :vat_zone, :currency_handle, :term_of_payment_handle, :is_accessible, :ci_number, :email, :address, :postal_code, :city, :country, :bank_account, :attention_handle, :your_reference_handle, :our_reference_handle, :default_payment_type_handle, :default_payment_creditor_id, :county, :auto_contra_account_handle

    def handle
      @handle || Handle.build({:number => @number})
    end

    # Returns the Creditors contacts
    def contacts
      @contacts ||= CreditorContactProxy.new(self)
    end

    protected

    def build_soap_data
      data = {}

      data['Handle'] = handle.to_hash
      data['Number'] = handle.number
      data['CreditorGroupHandle'] = { 'Number' => creditor_group_handle[:number] } unless creditor_group_handle.blank?
      data['Name'] = name unless name.blank?
      data['VatZone'] = vat_zone unless vat_zone.blank?
      data['CurrencyHandle'] = { 'Code' => currency_handle[:code] } unless currency_handle.blank?
      data['TermOfPaymentHandle'] = { 'Id' => term_of_payment_handle[:id] } unless term_of_payment_handle.blank?
      data['IsAccessible'] = is_accessible unless is_accessible.blank?
      data['CINumber'] = ci_number unless ci_number.blank?
      data['Email'] = email unless email.blank?
      data['Address'] = address unless address.blank?
      data['PostalCode'] = postal_code unless postal_code.blank?
      data['City'] = city unless city.blank?
      data['Country'] = country unless country.blank?
      data['BankAccount'] = bank_account unless bank_account.blank?
      data['AttentionHandle'] = { 'Id' => attention_handle[:id] } unless attention_handle.blank?
      data['YourReferenceHandle'] = { 'Id' => your_reference_handle[:id] } unless your_reference_handle.blank?
      data['OurReferenceHandle'] = { 'Number' => our_reference_handle[:number] } unless our_reference_handle.blank?
      data['DefaultPaymentTypeHandle'] = { 'Number' => default_payment_type_handle[:number] } unless default_payment_type_handle.blank?
      data['DefaultPaymentCreditorId'] = default_payment_creditor_id unless default_payment_creditor_id.blank?
      data['County'] = county unless county.blank?
      data['AutoContraAccountHandle'] = { 'Number' => auto_contra_account_handle[:number] } unless auto_contra_account_handle.blank?

      data
    end
  end
end
