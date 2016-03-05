require "./spec/spec_helper"

describe Economic::Endpoint do
  subject { Economic::Endpoint.new }

  describe "call" do
    let(:client) {
      subject.client
    }

    it "uses the SOAP client to invoke a SOAP action on the API" do
      expect(client).to receive(:call).with(
        :foo_bar,
        :message => {:baz => "qux"}
      ).and_return({})
      subject.call(:foo_bar, :baz => "qux")
    end

    it "sends an actual request" do
      mock_request("Connect", nil, :success)
      subject.call(:connect)
    end

    it "returns a hash with data" do
      stub_request("CurrentInvoice_GetAll", nil, :single)
      expect(subject.call(:current_invoice_get_all)).to eq(:current_invoice_handle => {:id => "1"})
    end

    it "returns an empty hash if no data returned" do
      stub_request("CurrentInvoice_GetAll", nil, :none)
      expect(subject.call(:current_invoice_get_all)).to be_empty
    end

    it "yields a Savon response" do
      stub_request("CurrentInvoice_GetAll", nil, :single)
      @yielded_value = nil
      subject.call(:current_invoice_get_all) do |response|
        @yielded_value = response
      end
      expect(@yielded_value).to be_instance_of(Savon::Response)
    end

    it "adds a cookie header" do
      expect(client).to receive(:call).with(
        :current_invoice_get_all,
        :cookies => "omnomnom"
      ).and_return({})
      subject.call(:current_invoice_get_all, {}, "omnomnom")
    end
  end

  describe "#client" do
    it "returns a Savon::Client" do
      expect(subject.client).to be_instance_of(::Savon::Client)
    end

    it "returns the same Savon::Client" do
      expect(subject.client).to equal(subject.client)
    end
  end

  describe "soap_action_name" do
    it "returns full action name for the given class and soap action" do
      expect(subject.soap_action_name(Economic::Debtor, :get_data)).to eq(:debtor_get_data)
    end

    it "returns full action name for a class given as strings" do
      expect(subject.soap_action_name("FooBar", "Stuff")).to eq(:foo_bar_stuff)
    end
  end

  describe "savon globals configuration" do
    it "sets the log_level option of the endpoint" do
      expect(subject.client.globals).to receive(:log_level).with(:fatal)
      subject.log_level = :fatal
    end

    it "sets the log option of the endpoint" do
      expect(subject.client.globals).to receive(:log).with(true)
      subject.log = true
    end

    it "sets the logger option of the boolean" do
      logger = double("MyLogger")
      expect(subject.client.globals).to receive(:logger).with(logger)
      subject.logger = logger
    end
  end

  describe "app identifier configuration" do
    let(:app_id) { "my awesome app v.4.0.9-beta-rc1" }

    it "can be instantiated with an app_identifier" do
      expect(Economic::Endpoint.new(app_id).client).to be_instance_of(::Savon::Client)
    end
  end
end
