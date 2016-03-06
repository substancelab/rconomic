require "economic/entity"

module Economic
  # Represents a creditor in E-conomic.
  #
  # API documentation: https://api.e-conomic.com/secure/api1/EconomicWebService.asmx?op=Company_GetData
  #
  # Examples
  #
  #   # Get company:
  #   creditor = economic.company.get
  #
  class Company < Entity
    property(:handle, :formatter => Properties::Formatters::HANDLE, :required => true)
    property(:number, :required => true)
    property(:base_currency_handle, :formatter => Properties::Formatters::HANDLE)
    property(:name)
    property(:address_1)
    property(:address_2)
    property(:postal_code)
    property(:city)
    property(:country)
    property(:telephone_number)
    property(:fax_number)
    property(:mobile_number)
    property(:contact)
    property(:website)
    property(:email)
    property(:c_i_number)
    property(:vat_number)
    property(:sign_up_date)

    def handle
      @handle || Handle.build(:number => @number)
    end
  end
end
