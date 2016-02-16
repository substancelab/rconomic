require 'economic/proxies/entity_proxy'

module Economic
  class OrderLineProxy < EntityProxy
    # Gets data for OrderLine from the API
    def find(handle)
      handle = Entity::Handle.build(:number => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

  private

    # Initialize properties in order_line with values from owner
    def initialize_properties_with_values_from_owner(order_line)
      if owner.is_a?(Order)
        order_line.order = owner
      end
      order_line
    end
  end
end
