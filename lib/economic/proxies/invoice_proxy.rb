require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_date_interval'
require 'economic/proxies/actions/find_by_handle_with_number'

module Economic
  class InvoiceProxy < EntityProxy
    include FindByDateInterval
    include FindByHandleWithNumber


    # Returns handle for invoices for debtor.
    def find_by_debtor_handle(handle)
      response = session.request(
        Endpoint.new.soap_action_name("Debtor", "GetInvoices"),
        {
          'debtorHandle' => { 'Number' => handle.number }
        }
      )
      if response == {}
        nil
      else
        entities = []
        response[:invoice_handle].each do |handle|
          entity = build
          entity.partial = true
          entity.persisted = true
          entity.handle = handle
          entity.number = handle[:number].to_i
          entities << entity
        end
        entities
      end
    end
  end
end
