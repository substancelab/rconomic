# Economic::Endpoint models the actual SOAP endpoint at E-conomic.
#
# This is where all knowledge of SOAP actions and requests exists.
class Economic::Endpoint

  # Invokes soap_action on the API endpoint with the given data.
  #
  # Returns a Hash with the resulting response from the endpoint as a Hash.
  #
  # If you need access to more details from the unparsed SOAP response, supply
  # a block to `call`. A Savon::SOAP::Response will be yielded to the block.
  def call(client, soap_action, data = {})
    response = request(client, soap_action, data)

    if block_given?
      yield response
    else
      extract_result_from_response(response, soap_action)
    end
  end

  # Returns the E-conomic API action name to call
  def soap_action_name(entity_class, action)
    class_name = entity_class.to_s
    class_name_without_modules = class_name.split('::').last
    "#{class_name_without_modules.snakecase}_#{action.to_s.snakecase}".intern
  end

  private

  def extract_result_from_response(response, soap_action)
    response_hash = response.to_hash

    response_key = "#{soap_action}_response".intern
    result_key = "#{soap_action}_result".intern

    if response_hash[response_key] && response_hash[response_key][result_key]
      response_hash[response_key][result_key]
    else
      {}
    end
  end

  def request(client, soap_action, data)
    client.request(:economic, soap_action) do
      soap.body = data
    end
  end
end
