require './spec/spec_helper'

describe Economic::Session do
  subject { Economic::Session.new(123456, 'api', 'passw0rd') }

  let(:endpoint) { subject.endpoint }

  describe "new" do
    it "should store authentication details" do
      subject.agreement_number.should == 123456
      subject.user_name.should == 'api'
      subject.password.should == 'passw0rd'
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
        :body => fixture(:connect, :success),
        :code => 200
      }
      stub_request('Connect', authentication_details, response)
      subject.connect
      subject.authentication_token.should == "cookie value from e-conomic"
    end

    it "updates the authentication token for new sessions" do
      stub_request("Connect", nil, {:headers => {"Set-Cookie" => "authentication token"}})
      subject.connect

      stub_request('Connect', nil, {:headers => {"Set-Cookie" => "another token"}})
      other_session = Economic::Session.new(123456, 'api', 'passw0rd')
      other_session.connect

      subject.authentication_token.should == "authentication token"
      other_session.authentication_token.should == "another token"
    end

    it "removes existing cookie header before connecting" do
      endpoint.should_receive(:call).with(:connect, an_instance_of(Hash), {"Cookie" => nil})
      subject.connect
    end
  end

  describe ".endpoint" do
    it "returns Economic::Endpoint" do
      subject.endpoint.should be_instance_of(Economic::Endpoint)
    end
  end

  describe ".session" do
    it "returns self" do
      subject.session.should === subject
    end
  end

  describe "contacts" do
    it "returns a DebtorContactProxy" do
      subject.contacts.should be_instance_of(Economic::DebtorContactProxy)
    end

    it "memoizes the proxy" do
      subject.contacts.should === subject.contacts
    end
  end

  describe "current_invoices" do
    it "returns an CurrentInvoiceProxy" do
      subject.current_invoices.should be_instance_of(Economic::CurrentInvoiceProxy)
    end

    it "memoizes the proxy" do
      subject.current_invoices.should === subject.current_invoices
    end
  end

  describe "invoices" do
    it "returns an InvoiceProxy" do
      subject.invoices.should be_instance_of(Economic::InvoiceProxy)
    end

    it "memoizes the proxy" do
      subject.invoices.should === subject.invoices
    end
  end

  describe "debtors" do
    it "returns a DebtorProxy" do
      subject.debtors.should be_instance_of(Economic::DebtorProxy)
    end

    it "memoizes the proxy" do
      subject.debtors.should === subject.debtors
    end
  end

  describe "request" do
    it "sends a request to API" do
      endpoint.should_receive(:call).with(
        :invoice_get_all,
        {},
        "Cookie" => nil
      ).and_return({})
      subject.request(:invoice_get_all, {})
    end

    it "sends data if given" do
      mock_request(:current_invoice_get_all, {:bar => :baz}, :none)
      subject.request(:current_invoice_get_all, {:bar => :baz})
    end

    it "returns a hash with data" do
      stub_request(:current_invoice_get_all, nil, :single)
      subject.request(:current_invoice_get_all).should == {:current_invoice_handle => {:id => "1"}}
    end

    it "returns an empty hash if no data returned" do
      stub_request(:current_invoice_get_all, nil, :none)
      subject.request(:current_invoice_get_all).should be_empty
    end
  end

end
