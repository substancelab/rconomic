require "economic/proxies/entity_proxy"

module Economic
  class TemplateCollectionProxy < EntityProxy

    def find_by_name(name)
      Proxies::Actions::FindByName.new(self, name).call
    end
  end
end
