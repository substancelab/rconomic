require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_number"

module Economic
  class DebtorGroupProxy < EntityProxy
    include FindByNumber

    def find_by_name(name)
      Proxies::Actions::FindByName.new(self, name).call
    end
  end
end
