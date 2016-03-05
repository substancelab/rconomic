module FindByTelephoneAndFaxNumber
  # Returns handle for debtor with phone or fax number.
  def find_by_telephone_and_fax_number(number)
    response = request("FindByTelephoneAndFaxNumber", "telephoneAndFaxNumber" => number)
    if response == {}
      nil
    else
      entity = build
      entity.partial = true
      entity.persisted = true
      entity.handle = response[:debtor_handle]
      entity.number = response[:debtor_handle][:number].to_i
      entity
    end
  end
end
