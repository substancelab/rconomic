require "economic/entity"

module Economic
  class Order < Entity
    has_properties :number,
      :net_amount,
      :vat_amount,
      :gross_amount,
      :due_date,
      :debtor_handle,
      :debtor_name,
      :debtor_name,
      :debtor_address,
      :debtor_postal_code,
      :debtor_city,
      :debtor_country,
      :debtor_ean,
      :attention_handle,
      :heading

    def attention
      return nil if attention_handle.nil?
      @attention ||= session.contacts.find(attention_handle)
    end

    def attention=(contact)
      self.attention_handle = contact.handle
      @attention = contact
    end

    def attention_handle=(handle)
      @attention = nil unless handle == @attention_handle
      @attention_handle = handle
    end

    def debtor
      return nil if debtor_handle.nil?
      @debtor ||= session.debtors.find(debtor_handle)
    end

    def debtor=(debtor)
      self.debtor_handle = debtor.handle
      @debtor = debtor
    end

    def debtor_handle=(handle)
      @debtor = nil unless handle == @debtor_handle
      @debtor_handle = handle
    end

    # Returns the PDF version of Invoice as a String.
    #
    # To get it as a file you can do:
    #
    #   File.open("invoice.pdf", 'wb') do |file|
    #     file << invoice.pdf
    #   end
    def pdf
      response = request(:get_pdf, "orderHandle" => handle.to_hash)

      Base64.decode64(response)
    end
  end
end
