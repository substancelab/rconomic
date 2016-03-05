require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_ci_number"
require "economic/proxies/actions/find_by_handle_with_number"
require "economic/proxies/actions/find_by_number"
require "economic/proxies/actions/find_by_telephone_and_fax_number"

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

    def get_debtor_contacts(debtor_handle)
      response = request(
        :get_debtor_contacts,
        "debtorHandle" => {"Number" => debtor_handle.number}
      )
      return nil if response.empty?

      [response[:debtor_contact_handle]].flatten.map do |handle|
        entity = Economic::DebtorContact.new(:session => session)
        entity.partial = true
        entity.persisted = true
        entity.handle = handle
        entity.number = handle[:number].to_i
        entity
      end
    end

    def get_invoices(debtor_handle)
      response = request(
        :get_invoices,
        "debtorHandle" => {"Number" => debtor_handle.number}
      )
      return nil if response.empty?

      [response[:invoice_handle]].flatten.map do |handle|
        entity = Economic::Invoice.new(:session => session)
        entity.partial = true
        entity.persisted = true
        entity.handle = handle
        entity.number = handle[:number].to_i
        entity
      end
    end

    # Returns handle for orders for debtor.
    def get_orders(debtor_handle)
      response = request(
        :get_orders,
        "debtorHandle" => {"Number" => debtor_handle.number}
      )
      return nil if response.empty?

      [response[:order_handle]].flatten.map do |handle|
        entity = Economic::Order.new(:session => session)
        entity.partial = true
        entity.persisted = true
        entity.handle = handle
        entity.number = handle[:id].to_i
        entity
      end
    end
  end
end
