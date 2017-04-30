# frozen_string_literal: true

module Savon
  class SOAPRequest < HTTPRequest
    def build(options = {})
      configure_proxy
      configure_timeouts
      configure_headers options[:soap_action]
      configure_cookies options[:cookies]
      configure_ssl
      configure_auth
      configure_redirect_handling

      @http_request
    end
  end
end
