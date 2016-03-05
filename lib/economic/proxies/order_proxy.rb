require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_date_interval"
require "economic/proxies/actions/find_by_handle_with_number"

module Economic
  class OrderProxy < EntityProxy
    include FindByDateInterval
    include FindByHandleWithNumber

    def find(handle)
      if handle.is_a?(Hash)
        super handle
      else
        super({:id => handle})
      end
    end
  end
end
