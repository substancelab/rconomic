module Economic
  class Session
    attr_accessor :agreement_number, :user_name, :password

    def initialize(agreement_number, user_name, password)
      self.agreement_number = agreement_number
      self.user_name = user_name
      self.password = password
    end

    # Authenticates with e-conomic
    def connect
      client.http.headers["Cookie"] = nil
      response = client.request :economic, :connect do
        soap.body = {
          :agreementNumber => self.agreement_number,
          :userName => self.user_name,
          :password => self.password
        }
      end

      @cookie = response.http.headers["Set-Cookie"]
    end

    # Provides access to the DebtorContacts
    def contacts
      @contacts ||= DebtorContactProxy.new(self)
    end

    # Provides access to the current invoices - ie invoices that haven't yet been booked
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
    def request(action, data = nil)
      client.http.headers["Cookie"]  = @cookie

      response = client.request(:economic, action) do
        soap.body = data if data
      end
      response_hash = response.to_hash

      response_key = "#{action}_response".intern
      result_key = "#{action}_result".intern
      if response_hash[response_key] && response_hash[response_key][result_key]
        response_hash[response_key][result_key]
      else
        {}
      end
    end

    # Returns self - used by proxies to access the session of their owner
    def session
      self
    end

    private

    # Returns the Savon::Client used to connect to e-conomic
    # Cached on class-level to avoid loading the big wsdl file more than once (can take several hunder megabytes of ram after a while...)
    def client
      @@client ||= Savon::Client.new do
        wsdl.document = File.expand_path(File.join(File.dirname(__FILE__), "economic.wsdl"))
      end
    end
  end
end
