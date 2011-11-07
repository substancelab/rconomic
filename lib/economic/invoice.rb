require 'economic/entity'

module Economic
  class Invoice < Entity
    has_properties :number, :net_amount, :vat_amount, :due_date, :debtor_handle, :heading

    def remainder
      session.request(soap_action(:get_remainder)) do
        soap.body = { "invoiceHandle" => handle.to_hash }
      end
    end
  end
end
