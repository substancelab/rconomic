require './spec/spec_helper'

describe Economic::Endpoint do
  subject { Economic::Endpoint.new }

  describe "call" do
    let(:client) {
      subject.client
    }

    it "uses the SOAP client to invoke a SOAP action on the API" do
      expect(client).to receive(:call).with(
        :foo_bar,
        :message => {:baz => 'qux'}
      ).and_return({})
      subject.call(:foo_bar, {:baz => 'qux'})
    end

    it "sends an actual request" do
      mock_request('Connect', nil, :success)
      subject.call(:connect)
    end

    it "returns a hash with data" do
      stub_request('CurrentInvoice_GetAll', nil, :single)
      expect(subject.call(:current_invoice_get_all)).to eq({:current_invoice_handle => {:id => "1"}})
    end

    it "returns an empty hash if no data returned" do
      stub_request('CurrentInvoice_GetAll', nil, :none)
      expect(subject.call(:current_invoice_get_all)).to be_empty
    end

    it "yields a Savon response" do
      stub_request('CurrentInvoice_GetAll', nil, :single)
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
end
