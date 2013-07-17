module FindByNumber
  # Returns handle with a given number.
  def find_by_number(number)
    response = session.request(entity_class.soap_action_name('FindByNumber')) do
      soap.body = {
        'number' => number
      }
    end

    if response == {}
      nil
    else
      entity = build
      entity.partial = true
      entity.persisted = true
      entity.handle = response
      entity.number = response[:number].to_i
      entity
    end
  end
end
