require 'savon'
require "savon/mock/spec_helper"

if ENV['TRAVIS'] == "true"
  require 'coveralls'
  Coveralls.wear!
end

require './lib/rconomic'

RSpec.configure do |config|
  config.include Savon::SpecHelper

  config.before :each do
    # Ensure we don't actually send requests over the network
    HTTPI.should_receive(:get).never
    HTTPI.should_receive(:post).never
    savon.mock!
  end

  config.after :each do
    savon.unmock!
  end

end

def fixture(operation, fixture)
  fixture_path = File.join(
    "spec/fixtures",
    operation.to_s,
    "#{fixture}.xml"
  )
  File.read(fixture_path)
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

# Set up an expectation that a specific operation must be called with specific
# data in the message body, returning a specific response.
def mock_request(operation, data, response)
  operation = Economic::Support::String.underscore(operation)
  response = if response.is_a?(Symbol)
    fixture(operation, response)
  elsif response.is_a?(Hash)
    {:code => 200}.merge(response)
  end

  mock = savon.expects(operation.intern)
  mock.with(:message => data) if data
  mock.returns(response)
end

# Set up a fake request so that when operation is called with data in the 
# message body it returns the desired response.
def stub_request(operation, data, response)
  mock_request(operation, data || :any, response)
end
