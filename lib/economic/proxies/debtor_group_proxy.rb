require "economic/proxies/entity_proxy"
require "economic/proxies/actions/find_by_number"

module Economic
  class DebtorGroupProxy < EntityProxy
    include FindByNumber

    def find(handle)
      handle = Entity::Handle.build(:number => handle) unless handle.is_a?(Entity::Handle)
      super(handle)
    end

    def find_by_name(name)
      Proxies::Actions::FindByName.new(self, name).call
    end
  end
end
