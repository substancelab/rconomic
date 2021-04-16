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

    def handle
      @handle || Handle.build(number: @number)
    end

    protected

    # Returns the field rules to use when mapping to SOAP data
    def fields
      to_hash = proc { |handle| handle.to_hash }
      [
        ["Handle", :handle, to_hash],
        ["Id", :number],
        ["Number", :number],
        ["OrderHandle", :order_handle, to_hash],
        ["Description", :description],
        ["DeliveryDate", :delivery_date, nil, :required],
        ["UnitHandle", :unit_handle, to_hash],
        ["ProductHandle", :product_handle, to_hash],
        ["Quantity", :quantity],
        ["UnitNetPrice", :unit_net_price, nil, :required],
        ["DiscountAsPercent", :discount_as_percent],
        ["UnitCostPrice", :unit_cost_price],
        ["TotalNetAmount", :total_net_amount, nil, :required],
        ["TotalMargin", :total_margin],
        ["MarginAsPercent", :margin_as_percent],
        ["DepartmentHandle", :department_handle, to_hash],
        ["DistributionKeyHandle", :distribution_key_handle, to_hash],
        ["InventoryLocationHandle", :inventory_location_handle, to_hash]
      ]
    end
  end
end
