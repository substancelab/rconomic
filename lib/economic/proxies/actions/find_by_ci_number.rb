module FindByCiNumber
  # Returns Debtors that have the given ci_number. The Debtor objects will only
  # be partially loaded
  def find_by_ci_number(ci_number)
    # Get a list of handles from e-conomic
    response = request(:find_by_ci_number, "ciNumber" => ci_number)

    # Make sure we always have an array of handles even if the result only
    # contains one
    handle_key = "#{entity_class_name.downcase}_handle".intern
    handles = [response[handle_key]].flatten.reject(&:blank?)

    # Create partial Debtor entities
    handles.collect do |handle|
      entity = build
      entity.partial = true
      entity.persisted = true
      entity.handle = handle
      entity.number = handle[:number]
      entity
    end
  end
end
