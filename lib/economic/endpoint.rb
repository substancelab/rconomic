# Economic::Endpoint models the actual SOAP endpoint at E-conomic.
#
# This is where all knowledge of SOAP actions and requests exists.
class Economic::Endpoint

  # Invokes soap_action on the API endpoint with the given data.
  #
  # Returns a Hash with the resulting response from the endpoint as a Hash.
  #
  # If you need access to more details from the unparsed SOAP response, supply
  # a block to `call`. A Savon::Response will be yielded to the block.
  def call(soap_action, data = nil, cookies = nil)
    # set_client_headers(headers)

    response = request(soap_action, data, cookies)

    if block_given?
      yield response
    else
      extract_result_from_response(response, soap_action)
    end
  end

  # Returns a Savon::Client to connect to the e-conomic endpoint
  #
  # Cached on class-level to avoid loading the big WSDL file more than once (can
  # take several hundred megabytes of RAM after a while...)
  def client
    @@client ||= Savon.client do
      wsdl File.expand_path(File.join(File.dirname(__FILE__), "economic.wsdl"))
    end
  end

  def extract_result_from_response(response, soap_action)
    response = response.to_hash

    response_key = "#{soap_action}_response".intern
    result_key = "#{soap_action}_result".intern

    if response[response_key] && response[response_key][result_key]
      response[response_key][result_key]
    else
      {}
    end
  end

  def request(soap_action, data, cookies)
    locals = {}
    locals[:message] = data if data && !data.empty?
    locals[:cookies] = cookies if cookies && !cookies.empty?

    client.call(
      soap_action,
      locals
    )
  end
end
