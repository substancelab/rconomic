require 'economic/proxies/entity_proxy'

module Economic
  class InvoiceProxy < EntityProxy
    # Gets data for Invoice from the API
    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:number => handle.to_i)
      else
        Entity::Handle.new(handle)
      end
      super(handle)
    end

    # Returns Economic::Invoice objects for invoices in a given interval of days.
    def find_by_date_interval(from, unto)
      response = session.request entity_class.soap_action("FindByDateInterval") do
        soap.body = {
          'first' => from.iso8601,
          'last' => unto.iso8601,
          :order! => ['first', 'last']
        }
      end

      handles = [ response[:invoice_handle] ].flatten.reject(&:blank?)

      handles.collect do |handle|
        find(handle[:number])
      end
    end
  end
end
