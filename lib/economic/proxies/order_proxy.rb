require 'economic/proxies/entity_proxy'

module Economic
  class OrderProxy < EntityProxy

    # Returns handle for orders for debtor.
    def find_by_debtor_handle(handle)
      response = session.request(
        Endpoint.new.soap_action_name("Debtor", "GetOrders"),
        {
          'debtorHandle' => { 'Number' => handle.number }
        }
      )

      if response == {}
        nil
      else
        entities = []
        [response[:order_handle]].flatten.each do |handle|
          entity = build
          entity.partial = true
          entity.persisted = true
          entity.handle = handle
          entity.number = handle[:id].to_i
          entities << entity
        end
        entities
      end
    end
  end
end
