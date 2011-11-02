require 'economic/entity'

module Economic
  class Invoice < Entity
    has_properties :id, :net_amount, :vat_amount 
  end
end
