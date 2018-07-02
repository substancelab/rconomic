# frozen_string_literal: true

require "economic/proxies/entity_proxy"

module Economic
  class DebtorEntryProxy < EntityProxy
    def find_by_invoice_number(from, to = from)
      response = request("FindByInvoiceNumber", "from" => from,
                                                "to" => to)

      response[:debtor_entry_handle].map do |debtor_entry_handle|
        # Kinda ugly, but we get an array instead of a hash when there's only one result. :)
        Hash[*debtor_entry_handle.to_a.flatten][:serial_number].to_i
      end
    end

    def match(*serial_numbers)
      request("MatchEntries", :entries => {
        "DebtorEntryHandle" => serial_numbers.map { |serial_number|
          {"SerialNumber" => serial_number}
        }
      })
    end
  end
end
