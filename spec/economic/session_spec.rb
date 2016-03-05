require "./spec/spec_helper"

describe Economic::Session do
  let(:credentials) { [123_456, "api", "passw0rd"] }
  subject { Economic::Session.new }

  let(:endpoint) { subject.endpoint }

  describe "new" do
    describe "legacy connect" do
      subject { Economic::Session.new(*credentials) }
      it "should store authentication details" do
        expect(subject.agreement_number).to eq(123_456)
        expect(subject.user_name).to eq("api")
        expect(subject.password).to eq("passw0rd")
      end

      it "can also store an app_id" do
        session = Economic::Session.new(*credentials, "app_id")
        expect(session.app_identifier).to eq("app_id")
      end
    end

    it "yields the endpoint if a block is given" do
      endpoint_mock = double("Endpoint")
      allow(Economic::Endpoint).to receive(:new).and_return(endpoint_mock)
      expect {|b|
        Economic::Session.new(123_456, "api", "passw0rd", &b)
      }.to yield_with_args(endpoint_mock)
    end
  end

  describe "connect" do
    let(:authentication_details) {
      {
        :agreementNumber => 123_456,
        :userName => "api",
        :password => "passw0rd"
      }
    }

    it "can connect old-style" do
      mock_request(:connect, authentication_details, :success)
      e = Economic::Session.new(*credentials)
      e.connect
    end

    it "connects to e-conomic with authentication details" do
      mock_request(:connect, authentication_details, :success)
      subject.connect_with_credentials(*credentials)
    end

    it "stores the authentication token for later requests" do
      response = {
        :headers => {"Set-Cookie" => "cookie value from e-conomic"},
        :body => fixture(:connect, :success)
      }
      stub_request("Connect", authentication_details, response)

      subject.connect_with_credentials(*credentials)

      expect(subject.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["cookie value from e-conomic"])
    end

    it "updates the authentication token for new sessions" do
      stub_request(
        "Connect",
        nil,
        :headers => {"Set-Cookie" => "authentication token"}
      )
      subject.connect_with_credentials(*credentials)

      stub_request(
        "Connect",
        nil,
        :headers => {"Set-Cookie" => "another token"}
      )
      other_session = Economic::Session.new
      other_session.connect_with_credentials(123_456, "api", "passw0rd")

      expect(subject.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["authentication token"])
      expect(other_session.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["another token"])
    end

    it "doesn't use existing authentication details when connecting" do
      expect(endpoint).to receive(:call).with(:connect, instance_of(Hash))
      subject.connect_with_credentials(*credentials)
    end
  end

  describe "connecting with access ID" do
    # As per http://www.e-conomic.com/developer/tutorials
    let(:authentication_details) {
      {
        :appToken => "the_private_app_id",
        :token => "the_access_id_you_got_from_the_grant"
      }
    }
    let(:private_app_id) { authentication_details[:appToken] }
    let(:access_id) { authentication_details[:token] }
    subject { Economic::Session.new }
    it "connects to e-conomic with tokens details" do
      mock_request(:connect_with_token, authentication_details, :success)
      subject.connect_with_token private_app_id, access_id
    end

    it "stores the authentication token for later requests" do
      response = {
        :headers => {"Set-Cookie" => "cookie value from e-conomic"},
        :body => fixture(:connect_with_token, :success)
      }
      stub_request("ConnectWithToken", authentication_details, response)

      subject.connect_with_token private_app_id, access_id

      expect(subject.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["cookie value from e-conomic"])
    end

    it "updates the authentication token for new sessions" do
      stub_request(
        "ConnectWithToken",
        nil,
        :headers => {"Set-Cookie" => "authentication token"}
      )
      subject.connect_with_token private_app_id, access_id

      stub_request(
        "Connect",
        nil,
        :headers => {"Set-Cookie" => "another token"}
      )
      other_session = Economic::Session.new
      other_session.connect_with_credentials(123_456, "api", "passw0rd")

      expect(subject.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["authentication token"])
      expect(other_session.authentication_token.collect { |cookie|
        cookie.name_and_value.split("=").last
      }).to eq(["another token"])
    end

    it "doesn't use existing authentication details when connecting" do
      expect(endpoint).to receive(:call).with(
        :connect_with_token,
        instance_of(Hash)
      )
      subject.connect_with_token private_app_id, access_id
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
      expect(subject.current_invoices).to be_instance_of(
        Economic::CurrentInvoiceProxy
      )
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
      subject.request(:current_invoice_get_all, :bar => :baz)
    end

    it "returns a hash with data" do
      stub_request(:current_invoice_get_all, nil, :single)
      expect(subject.request(:current_invoice_get_all)).to eq(
        :current_invoice_handle => {:id => "1"}
      )
    end

    it "returns an empty hash if no data returned" do
      stub_request(:current_invoice_get_all, nil, :none)
      expect(subject.request(:current_invoice_get_all)).to be_empty
    end
  end

  describe "savon configuration" do
    let(:endpoint) { double("Endpoint") }

    before :each do
      allow(Economic::Endpoint).to receive(:new).and_return(endpoint)
    end

    it "sets the log_level option of the endpoint" do
      expect(endpoint).to receive(:log_level=).with(:info)
      subject.log_level = :info
    end

    it "sets the log option of the endpoint" do
      expect(endpoint).to receive(:log=).with(true)
      subject.log = true
    end

    it "sets the logger option of the boolean" do
      logger = double("MyLogger")
      expect(endpoint).to receive(:logger=).with(logger)
      subject.logger = logger
    end
  end
end
