require "forwardable"

module Economic
  # The Economic::Session contains details and behaviors for a current
  # connection to the API endpoint.
  class Session
    extend Forwardable

    def_delegators :endpoint, :logger=, :log_level=, :log=

    attr_reader :authentication_cookies

    def initialize
      yield endpoint if block_given?
    end

    # Connect/authenticate with an API token and app id
    #
    # Reference: http://techtalk.e-conomic.com/why-were-implementing-a-new-api-connection-model/
    #
    # ==== Attributes
    #
    # * +private_app_id+ - The App ID created in your developer agreement
    # * +access_id+ - The Access ID or token for your App ID
    #
    def connect_with_token(private_app_id, access_id)
      endpoint.call(
        :connect_with_token,
        :token => access_id,
        :appToken => private_app_id
      ) do |response|
        store_authentication_cookies(response)
      end
    end

    # Provides access to the DebtorContacts
    def contacts
      @contacts ||= DebtorContactProxy.new(self)
    end

    # Provides access to the current invoices - ie invoices that haven't yet
    # been booked
    def current_invoices
      @current_invoices ||= CurrentInvoiceProxy.new(self)
    end

    # Provides access to the invoices
    def invoices
      @invoices ||= InvoiceProxy.new(self)
    end

    # Provides access to the orders
    def orders
      @orders ||= OrderProxy.new(self)
    end

    # Provides access to the debtors
    def debtors
      @debtors ||= DebtorProxy.new(self)
    end

    # Provides access to creditors
    def creditors
      @creditors ||= CreditorProxy.new(self)
    end

    def cash_books
      @cash_books ||= CashBookProxy.new(self)
    end

    def cash_book_entries
      @cash_book_entries ||= CashBookEntryProxy.new(self)
    end

    def accounts
      @accounts ||= AccountProxy.new(self)
    end

    def debtor_entries
      @debtor_entries ||= DebtorEntryProxy.new(self)
    end

    def creditor_entries
      @creditor_entries ||= CreditorEntryProxy.new(self)
    end

    def entries
      @entries ||= EntryProxy.new(self)
    end

    # Provides access to products
    def products
      @products ||= ProductProxy.new(self)
    end

    def company
      @company ||= CompanyProxy.new(self)
    end

    # Requests an action from the API endpoint
    def request(soap_action, data = nil)
      endpoint.call(soap_action, data, authentication_cookies)
    end

    # Returns self - used by proxies to access the session of their owner
    def session
      self
    end

    # Returns the SOAP endpoint to connect to
    def endpoint
      @endpoint ||= Economic::Endpoint.new
    end

    private

    def store_authentication_cookies(response)
      cookies = response.http.cookies
      @authentication_cookies = cookies
    end
  end
end
