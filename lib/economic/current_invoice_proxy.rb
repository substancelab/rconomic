module Economic
  class CurrentInvoiceProxy
    attr_reader :session

    def initialize(session)
      @session = session
    end

    # Returns a new, unpersisted Economic::CurrentInvoice
    def build(values = {})
      invoice = Economic::CurrentInvoice.new(values)
      invoice.session = session
      invoice
    end
  end
end