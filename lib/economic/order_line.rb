# frozen_string_literal: true

require "economic/entity"

module Economic
  class OrderLine < Entity
    has_properties :number,
      :order_handle,
      :description,
      :delivery_date,
      :unit_handle,
      :product_handle,
      :quantity,
      :unit_net_price,
      :discount_as_percent,
      :unit_cost_price,
      :total_net_amount,
      :total_margin,
      :margin_as_percent,
      :department_handle,
      :distribution_key_handle,
      :inventory_location_handle
  end
end
