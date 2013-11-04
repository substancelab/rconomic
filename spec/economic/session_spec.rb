require './spec/spec_helper'

describe Economic::Session do
  subject { Economic::Session.new(123456, 'api', 'passw0rd') }

  let(:endpoint) { subject.endpoint }

  describe "new" do
    it "should store authentication details" do
      expect(subject.agreement_number).to eq(123456)
      expect(subject.user_name).to eq('api')
      expect(subject.password).to eq('passw0rd')
    end
  end

  describe "connect" do
    let(:authentication_details) { {:agreementNumber => 123456, :userName => 'api', :password => 'passw0rd'} }

    it "connects to e-conomic with authentication details" do
      mock_request(:connect, authentication_details, :success)
      subject.connect
    end

    it "stores the authentication token for later requests" do
      response = {
        :headers => {'Set-Cookie' => 'cookie value from e-conomic'},
        :body => fixture(:connect, :success)
      }
      stub_request('Connect', authentication_details, response)

      subject.connect

      expect(subject.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["cookie value from e-conomic"])
    end

    it "updates the authentication token for new sessions" do
      stub_request("Connect", nil, {:headers => {"Set-Cookie" => "authentication token"}})
      subject.connect

      stub_request('Connect', nil, {:headers => {"Set-Cookie" => "another token"}})
      other_session = Economic::Session.new(123456, 'api', 'passw0rd')
      other_session.connect

      expect(subject.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["authentication token"])
      expect(other_session.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["another token"])
    end

    it "doesn't use existing authentication details when connecting" do
      expect(endpoint).to receive(:call).with(:connect, instance_of(Hash))
      subject.connect
    end
  end

  describe ".endpoint" do
    it "returns Economic::Endpoint" do
      expect(subject.endpoint).to be_instance_of(Economic::Endpoint)
    end
  end

  describe ".session" do
    it "returns self" do
      expect(subject.session).to equal(subject)
    end
  end

  describe "contacts" do
    it "returns a DebtorContactProxy" do
      expect(subject.contacts).to be_instance_of(Economic::DebtorContactProxy)
    end

    it "memoizes the proxy" do
      expect(subject.contacts).to equal(subject.contacts)
    end
  end

  describe "current_invoices" do
    it "returns an CurrentInvoiceProxy" do
      expect(subject.current_invoices).to be_instance_of(Economic::CurrentInvoiceProxy)
    end

    it "memoizes the proxy" do
      expect(subject.current_invoices).to equal(subject.current_invoices)
    end
  end

  describe "invoices" do
    it "returns an InvoiceProxy" do
      expect(subject.invoices).to be_instance_of(Economic::InvoiceProxy)
    end

    it "memoizes the proxy" do
      expect(subject.invoices).to equal(subject.invoices)
    end
  end

  describe "debtors" do
    it "returns a DebtorProxy" do
      expect(subject.debtors).to be_instance_of(Economic::DebtorProxy)
    end

    it "memoizes the proxy" do
      expect(subject.debtors).to equal(subject.debtors)
    end
  end

  describe "request" do
    it "sends a request to API" do
      expect(endpoint).to receive(:call).with(
        :invoice_get_all,
        {},
        nil
      ).and_return({})
      subject.request(:invoice_get_all, {})
    end

    it "sends data if given" do
      mock_request(:current_invoice_get_all, {:bar => :baz}, :none)
      subject.request(:current_invoice_get_all, {:bar => :baz})
    end

    it "returns a hash with data" do
      stub_request(:current_invoice_get_all, nil, :single)
      expect(subject.request(:current_invoice_get_all)).to eq({:current_invoice_handle => {:id => "1"}})
    end

    it "returns an empty hash if no data returned" do
      stub_request(:current_invoice_get_all, nil, :none)
      expect(subject.request(:current_invoice_get_all)).to be_empty
    end
  end

end
