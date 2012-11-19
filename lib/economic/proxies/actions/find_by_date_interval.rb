module FindByDateInterval

  # Returns entity objects for a given interval of days.
  def find_by_date_interval(from, unto)
    response = session.request entity_class.soap_action("FindByDateInterval") do
      soap.body = {
        'first' => from.iso8601,
        'last' => unto.iso8601,
        :order! => ['first', 'last']
      }
    end

    handle_key = "#{Economic::Support::String.underscore(entity_class_name)}_handle".intern
    handles = [ response[handle_key] ].flatten.reject(&:blank?)

    handles.collect do |handle|
      find(handle[:id])
    end
  end

end
