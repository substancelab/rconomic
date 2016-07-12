require "economic/entity"

module Economic
  class Invoice < Entity
    has_properties :number,
      :net_amount,
      :vat_amount,
      :gross_amount,
      :date,
      :due_date,
      :debtor_handle,
      :debtor_name,
      :debtor_address,
      :debtor_postal_code,
      :debtor_city,
      :debtor_country,
      :debtor_ean,
      :attention_handle,
      :heading,
      :other_reference

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

    def remainder
      @remainder ||= request(:get_remainder, "invoiceHandle" => handle.to_hash).to_f
    end

    def days_past_due
      days = Date.today - due_date.to_date
      days > 0 ? days : 0
    end

    # Returns true if the due date has expired, and there is a remainder
    # left on the invoice
    def past_due?
      days_past_due > 0 && remainder > 0
    end

    # Returns the PDF version of Invoice as a String.
    #
    # To get it as a file you can do:
    #
    #   File.open("invoice.pdf", 'wb') do |file|
    #     file << invoice.pdf
    #   end
    def pdf
      response = request(:get_pdf, "invoiceHandle" => handle.to_hash)

      Base64.decode64(response)
    end
  end
end
