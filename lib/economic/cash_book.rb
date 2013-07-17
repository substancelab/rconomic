require 'economic/entity'

module Economic

  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBook < Entity
    has_properties :name, :number

    def handle
      @handle ||= Handle.new({:number => @number})
    end

    def entries
      CashBookEntryProxy.new(self)
    end

    # Books all entries in the cashbook. Returns book result.
    def book
      response = session.request(soap_action_name(:book)) do
        soap.body = { "cashBookHandle" => handle.to_hash }
      end
      response[:number].to_i
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Name'] = name
      data['Number'] = number

      return data
    end
  end
end
