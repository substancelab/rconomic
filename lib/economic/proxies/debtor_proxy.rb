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
      response = fetch_response(:get_debtor_contacts, debtor_handle)
      build_entities_from_response(
        Economic::DebtorContact,
        response[:debtor_contact_handle]
      )
    end

    def get_invoices(debtor_handle)
      response = fetch_response(:get_invoices, debtor_handle)
      build_entities_from_response(
        Economic::Invoice,
        response[:invoice_handle]
      )
    end

    # Returns handle for orders for debtor.
    def get_orders(debtor_handle)
      response = fetch_response(:get_orders, debtor_handle)
      build_entities_from_response(
        Economic::Order,
        response[:order_handle]
      )
    end

    private

    def build_entities_from_response(entity_class, handles)
      return nil if handles.nil?
      [handles].flatten.map do |handle|
        entity = entity_class.new(:session => session)
        entity.partial = true
        entity.persisted = true
        entity.handle = handle
        entity.number = handle[:id].to_i
        entity
      end
    end

    def fetch_response(operation, debtor_handle)
      request(
        operation,
        "debtorHandle" => {"Number" => debtor_handle.number}
      )
    end
  end
end
