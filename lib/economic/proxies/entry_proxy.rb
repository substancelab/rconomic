require 'economic/proxies/entity_proxy'

module Economic
  class EntryProxy < EntityProxy
    def find_by_date_interval(from_date, to_date)
      response = session.request(entity_class.soap_action('FindByDateInterval')) do
        soap.body = {
          'fromDate' => from_date,
          'toDate' => to_date
        }
      end

      (response[:entry_handle] || []).map do |entry_handle|
        # Kinda ugly, but we get an array instead of a hash when there's only one result. :)
        Hash[*entry_handle.to_a.flatten][:serial_number].to_i
      end
    end

    def find(serial_number)
      response = session.request(entity_class.soap_action('GetData')) do
        soap.body = {
          'entityHandle' => {
            'SerialNumber' => serial_number
           }
        }
      end

      build(response)
    end
  end
end
