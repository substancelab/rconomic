require 'savon'
require 'savon_spec'
require 'lib/rconomic'

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

def stub_session
  Economic::Session.new(123456, 'api', 'passw0rd')
end