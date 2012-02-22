module Economic
  class Session
    attr_accessor :agreement_number, :user_name, :password

    def initialize(agreement_number, user_name, password)
      self.agreement_number = agreement_number
      self.user_name = user_name
      self.password = password
    end

    # Returns the Savon::Client used to connect to e-conomic
    def client
      @client ||= Savon::Client.new do
        wsdl.document = File.expand_path(File.join(File.dirname(__FILE__), "economic.wsdl"))
      end
    end

    # Authenticates with e-conomic
    def connect
      response = client.request :economic, :connect do
        soap.body = {
          :agreementNumber => self.agreement_number,
          :userName => self.user_name,
          :password => self.password,
          :order! => [:agreementNumber, :userName, :password]
        }
      end
      client.http.headers["Cookie"] = response.http.headers["Set-Cookie"]
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

    def request(action, &block)
      response = client.request :economic, action, &block
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
  end
end
