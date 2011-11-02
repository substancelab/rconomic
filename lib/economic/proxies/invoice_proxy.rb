require 'economic/proxies/entity_proxy'

module Economic
  class InvoiceProxy < EntityProxy
    # Gets data for Invoice from the API
    def find(handle)
      handle = Entity::Handle.new(:number => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

    def find_by_date_interval(from, unto)
      response = session.request entity_class.soap_action("FindByDateInterval") do
        soap.body = {
          'first' => from.iso8601,
          'last' => unto.iso8601
        }
      end

      handles = [ response[:invoice_handle] ].flatten.reject(&:blank?)

      handles.collect do |handle|
        find(handle[:number])
      end
    end
  end
end
