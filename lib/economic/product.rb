require "economic/entity"

module Economic
  # Represents a product in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IProduct.html
  #
  # Examples
  #
  #   # Find a product:
  #   product = economic.products.find(1234)
  #
  #   # Creating a product:
  #   product = economic.products.build
  #   product.number = 'ESC2014-LED-DISPLAY'
  #   product.product_group_handle = { :number => 1 }
  #   product.name = '100 meter LED display'
  #   product.sales_price = 999999
  #   product.cost_price = 100000
  #   product.recommended_price = 999999
  #   product.is_accessible = true
  #   product.volume = 1
  #   product.save
  class Product < Entity
    has_properties :number,
      :product_group_handle,
      :name,
      :description,
      :bar_code,
      :sales_price,
      :cost_price,
      :recommended_price,
      :unit_handle,
      :is_accessible,
      :volume,
      :department_handle,
      :distribution_key_handle,
      :in_stock,
      :on_order,
      :ordered,
      :available

    def handle
      @handle ||= Handle.new(:number => @number)
    end

    protected

    def fields
      to_hash = proc { |handle| handle.to_hash }
      [
        ["Handle", :handle, to_hash, :required],
        ["Number", :handle, proc { |h| h.number }, :required],
        ["ProductGroupHandle", :product_group_handle, to_hash],
        ["Name", :name, nil, :required],
        ["Description", :description, nil],
        ["BarCode", :bar_code, nil],
        ["SalesPrice", :sales_price, nil, :required],
        ["CostPrice", :cost_price, nil, :required],
        ["RecommendedPrice", :recommended_price, nil, :required],
        ["UnitHandle", :unit_handle, to_hash],
        ["IsAccessible", :is_accessible, nil, :required],
        ["Volume", :volume, nil, :required],
        ["DepartmentHandle", :department_handle, to_hash],
        ["DistributionKeyHandle", :distribution_key_handle, to_hash],
        ["InStock", :in_stock],
        ["OnOrder", :on_order],
        ["Ordered", :ordered],
        ["Available", :available]
      ]
    end
  end
end
