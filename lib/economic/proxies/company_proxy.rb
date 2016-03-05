require "economic/proxies/entity_proxy"

module Economic
  class CompanyProxy < EntityProxy
    def get
      get_data(request(:get))
    end
  end
end
