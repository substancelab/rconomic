require 'economic/entity'

module Economic
  class Invoice < Entity
    has_properties :number, :net_amount, :vat_amount, :due_date, :debtor_handle, :heading
  end
end
