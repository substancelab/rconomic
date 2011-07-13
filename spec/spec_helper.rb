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

module Savon
  module WSDL
    class Request
      def response
        # Return the fixture WSDL rather than the online one
        HTTPI::Response.new(200, {}, Savon::Spec::Fixture['wsdl'])
      end
    end
  end
end

def make_session
  Economic::Session.new(123456, 'api', 'passw0rd')
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