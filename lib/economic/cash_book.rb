require "economic/entity"

module Economic
  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBook < Entity
    property(:handle, "Handle", :required => true, :formatter => proc { |h| h.to_hash })
    property(:name, "Name", :required => true)
    property(:number, "Number", :required => true)

    def handle
      @handle || Handle.new(:number => @number)
    end

    def entries
      CashBookEntryProxy.new(self)
    end

    # Books all entries in the cashbook. Returns book result.
    def book
      response = request(:book, "cashBookHandle" => handle.to_hash)
      response[:number].to_i
    end
  end
end
