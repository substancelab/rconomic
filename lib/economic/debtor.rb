require "economic/entity"

module Economic
  # Represents a debtor in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtor.html
  #
  # Examples
  #
  #   # Find a debtor:
  #   debtor = economic.debtors.find(558)
  #
  #   # Creating a debtor:
  #   debtor = economic.debtors.build
  #   debtor.number = economic.debtors.next_available_number
  #   debtor.debtor_group_handle = { :number => 1 }
  #   debtor.name = 'Apple Inc'
  #   debtor.vat_zone = 'HomeCountry' # HomeCountry, EU, Abroad
  #   debtor.currency_handle = { :code => 'DKK' }
  #   debtor.price_group_handle = { :number => 1 }
  #   debtor.is_accessible = true
  #   debtor.ci_number = '12345678'
  #   debtor.term_of_payment_handle = { :id => 1 }
  #   debtor.layout_handle = { :id => 16 }
  #   debtor.save
  class Debtor < Entity
    has_properties :number,
      :debtor_group_handle,
      :name,
      :vat_zone,
      :currency_handle,
      :price_group_handle,
      :is_accessible,
      :ean,
      :public_entry_number,
      :email,
      :telephone_and_fax_number,
      :website,
      :address,
      :postal_code,
      :city,
      :country,
      :credit_maximum,
      :vat_number,
      :county,
      :ci_number,
      :term_of_payment_handle,
      :layout_handle,
      :attention_handle,
      :your_reference_handle,
      :our_reference_handle,
      :balance

    def handle
      @handle || Handle.new(:number => @number)
    end

    # Provides access to the current invoices for Debtor - ie invoices that
    # haven't yet been booked
    def current_invoices
      @current_invoices ||= CurrentInvoiceProxy.new(self)
    end

    # Returns the Debtors contacts
    def contacts
      return [] if handle.empty?
      @contacts ||= DebtorProxy.new(self).get_debtor_contacts(handle)
    end

    def invoices
      return [] if handle.empty?
      @invoices ||= DebtorProxy.new(self).get_invoices(handle)
    end

    def orders
      return [] if handle.empty?
      @orders ||= DebtorProxy.new(self).get_orders(handle)
    end

    protected

    def fields
      to_hash = proc { |handle| handle.to_hash }
      [
        ["Handle", :handle, to_hash, :required],
        ["Number", :handle, proc { |h| h.number }, :required],
        ["DebtorGroupHandle", :debtor_group_handle, to_hash],
        ["Name", :name, nil, :required],
        ["VatZone", :vat_zone, nil, :required],
        ["CurrencyHandle", :currency_handle, to_hash],
        ["PriceGroupHandle", :price_group_handle, to_hash],
        ["IsAccessible", :is_accessible, nil, :required],
        ["Ean", :ean],
        ["PublicEntryNumber", :public_entry_number],
        ["Email", :email],
        ["TelephoneAndFaxNumber", :telephone_and_fax_number],
        ["Website", :website],
        ["Address", :address],
        ["PostalCode", :postal_code],
        ["City", :city],
        ["Country", :country],
        ["CreditMaximum", :credit_maximum],
        ["VatNumber", :vat_number],
        ["County", :county],
        ["CINumber", :ci_number],
        ["TermOfPaymentHandle", :term_of_payment_handle, to_hash],
        ["LayoutHandle", :layout_handle, to_hash],
        ["AttentionHandle", :attention_handle],
        ["YourReferenceHandle", :your_reference_handle],
        ["OurReferenceHandle", :our_reference_handle],
        ["Balance", :balance]
      ]
    end
  end
end
