require './spec/spec_helper'

describe Economic::Endpoint do
  subject { Economic::Endpoint.new }

  describe "call" do
    let(:client) {
      subject.client
    }

    it "uses the SOAP client to invoke a SOAP action on the API" do
      client.expects(:request).with(:economic, :foo_bar).returns({})
      subject.call(:foo_bar, {:baz => 'qux'})
    end

    it "sends an actual request" do
      mock_request('Connect', nil, :success)
      subject.call(:connect)
    end

    it "returns a hash with data" do
      stub_request('CurrentInvoice_GetAll', nil, :single)
      subject.call(:current_invoice_get_all).should == {:current_invoice_handle => {:id => "1"}}
    end

    it "returns an empty hash if no data returned" do
      stub_request('CurrentInvoice_GetAll', nil, :none)
      subject.call(:current_invoice_get_all).should be_empty
    end

    it "yields a Savon response" do
      stub_request('CurrentInvoice_GetAll', nil, :single)
      @yielded_value = nil
      subject.call(:current_invoice_get_all) do |response|
        @yielded_value = response
      end
      @yielded_value.should be_instance_of(Savon::SOAP::Response)
    end

    it "adds a cookie header" do
      stub_request('CurrentInvoice_GetAll', nil, :single)
      subject.call(:current_invoice_get_all, {}, {"Cookie" => "omnomnom"})
      client.http.headers["Cookie"].should == "omnomnom"
    end

    it "deletes the cookie header" do
      stub_request('CurrentInvoice_GetAll', nil, :single)
      subject.call(:current_invoice_get_all, {}, {"Cookie" => nil})
      client.http.headers.should_not have_key("Cookie")
    end
  end

  describe "#client" do
    it "returns a Savon::Client" do
      subject.client.should be_instance_of(::Savon::Client)
    end

    it "returns the same Savon::Client" do
      subject.client.should === subject.client
    end
  end

  describe "soap_action_name" do
    it "returns full action name for the given class and soap action" do
      subject.soap_action_name(Economic::Debtor, :get_data).should == :debtor_get_data
    end

    it "returns full action name for a class given as strings" do
      subject.soap_action_name("FooBar", "Stuff").should == :foo_bar_stuff
    end
  end
end
