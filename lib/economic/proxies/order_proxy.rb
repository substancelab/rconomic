require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_date_interval"
require "economic/proxies/actions/find_by_handle_with_number"

module Economic
  class OrderProxy < EntityProxy
    include FindByDateInterval

  private

    # Initialize properties in invoice with values from owner
    def initialize_properties_with_values_from_owner(order)
      if owner.is_a?(Debtor)
        order.debtor = owner

        order.debtor_name         ||= owner.name
        order.debtor_address      ||= owner.address
        order.debtor_postal_code  ||= owner.postal_code
        order.debtor_city         ||= owner.city

        order.term_of_payment_handle  ||= owner.term_of_payment_handle
        order.layout_handle           ||= owner.layout_handle
        order.currency_handle         ||= owner.currency_handle
      end
    end
  end
end
