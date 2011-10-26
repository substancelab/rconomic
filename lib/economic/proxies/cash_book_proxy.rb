require 'economic/proxies/entity_proxy'

module Economic
  class CashBookProxy < EntityProxy
    def find_by_name(name)
      response = session.request entity_class.soap_action('FindByName') do
        soap.body = {
          'name' => name
        }
      end

      cash_book = build
      cash_book.partial = true
      cash_book.persisted = true
      cash_book.number = response[:number]
      cash_book

    end
    
    def all
      response = session.request entity_class.soap_action('GetAll')

      handles = [response[:cash_book_handle]].flatten.reject(&:blank?)
      cash_books = []
      handles.each do |handle|
        cash_books << find_name(handle[:number])
      end
      
      cash_books
    end
    
    def get_name(id)
      response = session.request entity_class.soap_action("GetName") do
        soap.body = {
          'cashBookHandle' => {
            'Number' => id
          }
        }
      end

      cash_book = build
      cash_book.number = id
      cash_book.name = response
      cash_book
    end
  end
end