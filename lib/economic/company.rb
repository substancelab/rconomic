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
    has_properties :number,
      :base_currency_handle,
      :name,
      :address_1,
      :address_2,
      :postal_code,
      :city,
      :country,
      :telephone_number,
      :fax_number,
      :mobile_number,
      :contact,
      :website,
      :email,
      :c_i_number,
      :vat_number,
      :sign_up_date
    def handle
      @handle || Handle.build(:number => @number)
    end

    protected

    def fields
      to_hash = proc { |h| h.to_hash }
      [
        ["Handle", :handle, to_hash, :required],
        ["Number", :number, nil, :required],
        ["BaseCurrencyHandle", :base_currency_handle, to_hash],
        ["Name", :name],
        ["Address1", :address_1],
        ["Address2", :address_2],
        ["PostalCode", :postal_code],
        ["City", :city],
        ["Country", :country],
        ["TelephoneNumber", :telephone_number],
        ["FaxNumber", :fax_number],
        ["MobileNumber", :mobile_number],
        ["Contact", :contact],
        ["WebSite", :website],
        ["Email", :email],
        ["CINumber", :c_i_number],
        ["VatNumber", :vat_number],
        ["SignUpDate", :sign_up_date]
      ]
    end
  end
end
