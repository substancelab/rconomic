require 'economic/proxies/entity_proxy'

module Economic
  class CashBookProxy < EntityProxy
    def find_by_name(name)
      response = request('FindByName', {
        'name' => name
      })

      cash_book = build
      cash_book.partial = true
      cash_book.persisted = true
      cash_book.number = response[:number]
      cash_book

    end
    
    def all
      response = request('GetAll')

      handles = [response[:cash_book_handle]].flatten.reject(&:blank?)
      cash_books = []
      handles.each do |handle|
        cash_books << get_name(handle[:number])
      end
      
      cash_books
    end
    
    def get_name(id)
      response = request("GetName", {
        'cashBookHandle' => {
          'Number' => id
        }
      })

      cash_book = build
      cash_book.number = id
      cash_book.name = response
      cash_book
    end
  end
end
