require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_ci_number'
require 'economic/proxies/actions/find_by_handle_with_number'
require 'economic/proxies/actions/find_by_number'
require 'economic/proxies/actions/find_by_telephone_and_fax_number'

module Economic
  class DebtorProxy < EntityProxy
    include FindByCiNumber
    include FindByHandleWithNumber
    include FindByNumber
    include FindByTelephoneAndFaxNumber

    # Returns the next available debtor number
    def next_available_number
      request :get_next_available_number
    end

    def get_invoices(debtor_handle)
      response = request :get_invoices, {
        'debtorHandle' => { 'Number' => debtor_handle.number }
      }
      if response.empty?
        nil
      else
        entities = []
        [response[:invoice_handle]].flatten.each do |handle|
          entity = Economic::Invoice.new(:session => session)
          entity.partial = true
          entity.persisted = true
          entity.handle = handle
          entity.number = handle[:number].to_i
          entities << entity
        end
        entities
      end
    end

    # Returns handle for orders for debtor.
    def get_orders(debtor_handle)
      response = request :get_orders, {
        'debtorHandle' => { 'Number' => debtor_handle.number }
      }
      if response.empty?
        nil
      else
        entities = []
        [response[:order_handle]].flatten.each do |handle|
          entity = Economic::Order.new(:session => session)
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
