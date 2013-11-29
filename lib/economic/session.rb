module Economic
  # The Economic::Session contains details and behaviors for a current
  # connection to the API endpoint.
  class Session
    extend Forwardable

    def_delegators :endpoint, :logger=, :log_level=, :log=

    attr_accessor :agreement_number, :user_name, :password
    attr_reader :authentication_token

    def initialize(agreement_number, user_name, password)
      self.agreement_number = agreement_number
      self.user_name = user_name
      self.password = password
    end

    # Authenticates with e-conomic
    def connect
      endpoint.call(
        :connect,
        authentication_details
      ) do |response|
        store_authentication_token(response)
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

    # Requests an action from the API endpoint
    def request(soap_action, data = nil)
      endpoint.call(soap_action, data, authentication_token)
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

    def authentication_details
      {
        :agreementNumber => self.agreement_number,
        :userName => self.user_name,
        :password => self.password
      }
    end

    def store_authentication_token(response)
      @authentication_token = response.http.cookies
    end
  end
end
