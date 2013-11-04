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
