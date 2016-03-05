require "economic/entity"

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
  #   creditor.number = 42
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
      @handle || Handle.build(:number => @number)
    end

    # Returns the Creditors contacts
    def contacts
      @contacts ||= CreditorContactProxy.new(self)
    end

    protected

    def fields
      to_hash = proc { |h| h.to_hash }
      [
        ["Handle", :handle, to_hash, :required],
        ["Number", :number, nil, :required],
        ["CreditorGroupHandle", :creditor_group_handle, to_hash],
        ["Name", :name],
        ["VatZone", :vat_zone],
        ["CurrencyHandle", :currency_handle, to_hash],
        ["TermOfPaymentHandle", :term_of_payment_handle, to_hash],
        ["IsAccessible", :is_accessible],
        ["CINumber", :ci_number],
        ["Email", :email],
        ["Address", :address],
        ["PostalCode", :postal_code],
        ["City", :city],
        ["Country", :country],
        ["BankAccount", :bank_account],
        ["AttentionHandle", :attention_handle, to_hash],
        ["YourReferenceHandle", :your_reference_handle, to_hash],
        ["OurReferenceHandle", :our_reference_handle, to_hash],
        ["DefaultPaymentTypeHandle", :default_payment_type_handle, to_hash],
        ["DefaultPaymentCreditorId", :default_payment_creditor_id, to_hash],
        ["County", :county],
        ["AutoContraAccountHandle", :auto_contra_account_handle, to_hash]
      ]
    end
  end
end
