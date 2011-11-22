require 'savon'
require 'savon_spec'
require './lib/rconomic'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include Savon::Spec::Macros

  config.before :each do
    # Ensure we don't actually send requests over the network
    HTTPI.expects(:get).never
    HTTPI.expects(:post).never
  end

end

Savon.configure do |config|
  config.logger = Logger.new(File.join('spec', 'debug.log'))
end

Savon::Spec::Fixture.path = File.expand_path("../fixtures", __FILE__)

# Stub the WSDL instead of fetching it over the wire
module Savon
  module Wasabi
    class Document < ::Wasabi::Document
      def resolve_document
        Savon::Spec::Fixture['wsdl']
      end
    end
  end
end


class Savon::Spec::Mock
  # Fix issue with savon_specs #with method, so that it allows other values than the expected.
  # Without this, savon_spec 0.1.6 doesn't work with savon 0.9.3.
  #
  #   savon.expects('Connect').with(has_entries(:agreementNumber => 123456)).returns(:success)
  #
  # would trigger a irrelevant
  #
  #   Mocha::ExpectationError: unexpected invocation: #<AnyInstance:Savon::SOAP::XML>.body=(nil)
  def with(soap_body)
    if mock_method == :expects
      Savon::SOAP::XML.any_instance.stubs(:body=)
      Savon::SOAP::XML.any_instance.expects(:body=).with(soap_body)
    end
    self
  end
end

def make_session
  Economic::Session.new(123456, 'api', 'passw0rd')
end

def make_current_invoice(properties = {})
  invoice = make_debtor.current_invoices.build

  # Assign specified properties
  properties.each { |key, value|
    invoice.send("#{key}=", value)
  }

  # Use defaults for the rest of the properties
  invoice.date ||= Time.now
  invoice.due_date ||= Time.now + 15
  invoice.exchange_rate ||= 100
  invoice.is_vat_included ||= false

  invoice
end

def make_debtor(properties = {})
  debtor = Economic::Debtor.new

  # Assign specified properties
  properties.each { |key, value|
    debtor.send("#{key}=", value)
  }

  # Use defaults for the rest of the properties
  debtor.session ||= make_session
  debtor.handle ||= { :number => 42 }
  debtor.number ||= 42
  debtor.debtor_group_handle || { :number => 1 }
  debtor.name ||= 'Bob'
  debtor.vat_zone ||= 'HomeCountry' # HomeCountry, EU, Abroad
  debtor.currency_handle ||= { :code => 'DKK' }
  debtor.price_group_handle ||= { :number => 1 }
  debtor.is_accessible ||= true
  debtor.ci_number ||= '12345678'
  debtor.term_of_payment_handle ||= { :id => 1 }
  debtor.layout_handle ||= { :id => 16 }

  debtor
end

def make_creditor(properties = {})
  creditor = Economic::Creditor.new

  # Assign specified properties
  properties.each { |key, value|
    creditor.send("#{key}=", value)
  }

  # Use defaults for the rest of the properties
  creditor.session ||= make_session
  creditor.handle ||= { :number => 42 }
  creditor.number ||= 42
  creditor.name ||= 'Bob'
  creditor.vat_zone ||= 'HomeCountry' # HomeCountry, EU, Abroad
  creditor.is_accessible ||= true
  creditor.ci_number ||= '12345678'

  creditor
end
