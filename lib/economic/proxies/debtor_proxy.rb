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
      build_entities_from_handles(:invoice, response[:invoice_handle])
    end

    def get_current_invoices(debtor_handle)
      response = request(:get_current_invoices, {
        'debtorHandle' => { 'Number' => debtor_handle.number }
      })
      build_entities_from_handles(:current_invoice, response[:current_invoice_handle])
    end

    def get_orders(debtor_handle)
      response = fetch_response(:get_orders, debtor_handle)
      build_entities_from_handles(:order, response[:order_handle])
    end

    private

    def build_entities_from_handles(class_name, handles)
      return nil if handles.nil?
      camelized_name = class_name.to_s.split('_').map{|e| e.capitalize}.join
      proxy = Economic.const_get("#{camelized_name}Proxy")
      proxy.get_data_array(handles).map! do |data|
        entity = proxy.build(data)
        entity.persisted = true
        entity.partial = false
        entity
      end
    end

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
