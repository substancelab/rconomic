require 'economic/proxies/entity_proxy'

module Economic
  class CashBookEntryProxy < EntityProxy
    def create_from_data
      entity_hash = session.request entity_class.soap_action(:get_data)  do
        soap.body = {
          'entityHandle' => {
            'Id' => id
          }
        }
      end
      entity = build(entity_hash)
      entity.persisted = true
      entity
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