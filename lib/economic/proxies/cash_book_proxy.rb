require 'economic/proxies/entity_proxy'

module Economic
  class CashBookProxy < EntityProxy
    def find_by_name(name)
      response = session.request entity_class.soap_action('FindByName') do
        soap.body = {
          'name' => name
        }
      end
      
      handles = [response[:cash_book_handle]].flatten.reject(&:blank?)

      # Create partial Debtor entities
      handles.collect do |handle|
        cash_book = build
        cash_book.partial = true
        cash_book.persisted = true
        cash_book.handle = handle
        cash_book.number = handle[:number]
        cash_book
      end
    end
    
    def all
      response = session.request entity_class.soap_action('GetAll')
    end
  end
end