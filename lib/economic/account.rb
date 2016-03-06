require "economic/entity"

module Economic
  class Account < Entity
    property(:handle, :formatter => Properties::Formatters::HANDLE, :required => true)
    property(:name, :required => true)
    property(:number, :required => true)
    property(:balance)
    property(:block_direct_entries)
    property(:contra_account)
    property(:debit_credit)
    property(:department)
    property(:distribution_key)
    property(:is_accessible)
    property(:opening_account)
    property(:total_from)
    property(:type)
    property(:vat_account)

    def handle
      Handle.build(:name => @name)
    end
  end
end
