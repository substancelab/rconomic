require 'economic/proxies/entity_proxy'

module Economic
  class CashBookEntryProxy < EntityProxy
    def all
      entity_hash = session.request(CashBookProxy.entity_class.soap_action(:get_entries)) do
        soap.body = { "cashBookHandle" => owner.handle.to_hash }
      end
      if entity_hash != {}
        [ entity_hash.values.first ].flatten.each do |id_hash|
          find(id_hash)
        end
      end
      self
    end

    def create_finance_voucher
      response = session.request entity_class.soap_action('CreateFinanceVoucher') do
        soap.body = {
          'cashBookHandle' => {'Number' => 1},
          'accountHandle' => {'Number' => 1010},
          'contraAccountHandle' => {'Number' => 1011}
        }
      end
    end
  end
end
