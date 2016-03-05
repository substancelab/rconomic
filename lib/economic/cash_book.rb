require "economic/entity"

module Economic
  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBook < Entity
    has_properties :name, :number

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

    protected

    def fields
      [
        ["Handle", :handle, proc { |h| h.to_hash }, :required],
        ["Name", :name, nil, :required],
        ["Number", :number, nil, :required]
      ]
    end
  end
end
