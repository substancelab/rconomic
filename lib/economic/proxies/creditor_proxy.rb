require 'economic/proxies/entity_proxy'

module Economic
  class CreditorProxy < EntityProxy

    # Fetches Creditor from API
    def find(handle)
      handle = if handle.respond_to?(:to_i)
        Entity::Handle.new(:number => handle.to_i)
      else
        Entity::Handle.new(handle)
      end
      super(handle)
    end

    # Returns Creditors that have the given ci_number. The Creditor objects will only be partially loaded
    def find_by_ci_number(ci_number)
      # Get a list of CreditorHandles from e-conomic
      response = session.request(entity_class.soap_action('FindByCINumber')) do
        soap.body = {
          'ciNumber' => ci_number
        }
      end

      # Make sure we always have an array of handles even if the result only contains one
      handles = [response[:creditor_handle]].flatten.reject(&:blank?)

      # Create partial Creditor entities
      handles.collect do |handle|
        creditor = build
        creditor.partial = true
        creditor.persisted = true
        creditor.handle = handle
        creditor.number = handle[:number]
        creditor
      end
    end

    # Returns handle with a given number.
    def find_by_number(number)
      response = session.request(entity_class.soap_action('FindByNumber')) do
        soap.body = {
          'number' => number
        }
      end

      if response == {}
        nil
      else
        creditor = build
        creditor.partial = true
        creditor.persisted = true
        creditor.handle = response
        creditor.number = response[:number].to_i
        creditor
      end
    end

    def create_simple(opts)
      response = session.request(entity_class.soap_action('Create')) do
        soap.body = {
          'number' => opts[:number],
          'creditorGroupHandle' => { 'Number' => opts[:creditor_group_handle][:number] },
          :name => opts[:name],
          :vatZone => opts[:vat_zone]
        }
      end

      find(response)
    end

  end
end
