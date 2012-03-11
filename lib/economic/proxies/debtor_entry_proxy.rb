require 'economic/proxies/entity_proxy'

module Economic
  class DebtorEntryProxy < EntityProxy
    def find_by_invoice_number(from, to = from)
      response = session.request(entity_class.soap_action('FindByInvoiceNumber')) do
        soap.body = {
          'from'  => from,
          'to'    => to,
          :order! => [ 'from', 'to' ]
        }
      end

      response[:debtor_entry_handle].map do |debtor_entry_handle|
        # Kinda ugly, but we get an array instead of a hash when there's only one result. :)
        Hash[*debtor_entry_handle.to_a.flatten][:serial_number].to_i
      end
    end

    def match(*serial_numbers)
      response = session.request(entity_class.soap_action('MatchEntries')) do
        soap.body = {
          :entries => {
            "DebtorEntryHandle" => serial_numbers.map { |serial_number|
              { "SerialNumber" => serial_number }
            }
          }
        }
      end
    end
  end
end
