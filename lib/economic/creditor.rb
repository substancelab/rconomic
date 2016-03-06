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
    property(:handle, :formatter => proc { |h| h.to_hash }, :required => true)
    property(:number, :required => true)
    property(:creditor_group_handle, :formatter => proc { |h| h.to_hash })
    property(:name)
    property(:vat_zone)
    property(:currency_handle, :formatter => proc { |h| h.to_hash })
    property(:term_of_payment_handle, :formatter => proc { |h| h.to_hash })
    property(:is_accessible)
    property(:ci_number)
    property(:email)
    property(:address)
    property(:postal_code)
    property(:city)
    property(:country)
    property(:bank_account)
    property(:attention_handle, :formatter => proc { |h| h.to_hash })
    property(:your_reference_handle, :formatter => proc { |h| h.to_hash })
    property(:our_reference_handle, :formatter => proc { |h| h.to_hash })
    property(:default_payment_type_handle, :formatter => proc { |h| h.to_hash })
    property(:default_payment_creditor_id, :formatter => proc { |h| h.to_hash })
    property(:county)
    property(:auto_contra_account_handle, :formatter => proc { |h| h.to_hash })

    def handle
      @handle || Handle.build(:number => @number)
    end

    # Returns the Creditors contacts
    def contacts
      @contacts ||= CreditorContactProxy.new(self)
    end
  end
end
