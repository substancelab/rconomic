require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_ci_number"
require "economic/proxies/actions/find_by_handle_with_number"
require "economic/proxies/actions/find_by_number"

module Economic
  class ProductProxy < EntityProxy
    include FindByHandleWithNumber
    include FindByNumber
  end
end
