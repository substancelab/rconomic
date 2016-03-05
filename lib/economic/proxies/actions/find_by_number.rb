module FindByNumber
  # Returns handle with a given number.
  def find_by_number(number)
    response = request("FindByNumber", "number" => number)

    if response.empty?
      nil
    else
      entity = build
      entity.partial = true
      entity.persisted = true
      entity.handle = response
      entity.number = response[:number]
      entity
    end
  end
end
