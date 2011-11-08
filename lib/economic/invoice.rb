require 'economic/entity'

module Economic
  class Invoice < Entity
    has_properties :number, :net_amount, :vat_amount, :due_date, :debtor_handle, :heading

    # Returns the PDF version of Invoice as a String.
    #
    # To get it as a file you can do:
    #
    #   File.open("invoice.pdf", 'wb') do |file|
    #     file << invoice.pdf
    #   end
    def pdf
      response = session.request soap_action(:get_pdf) do
        soap.body = { "invoiceHandle" => handle.to_hash }
      end

      Base64.decode64(response)
    end
  end
end
