require "economic/entity"

module Economic
  class Account < Entity
    property(:handle, "Handle", :formatter => proc { |handle| handle.to_hash }, :required => true)
    property(:name, "Name", :required => true)
    property(:number, "Number", :required => true)
    property(:balance, "Balance")
    property(:block_direct_entries, "BlockDirectEntries")
    property(:contra_account, "ContraAccount")
    property(:debit_credit, "DebitCredit")
    property(:department, "Department")
    property(:distribution_key, "DistributionKey")
    property(:is_accessible, "IsAccessible")
    property(:opening_account, "OpeningAccount")
    property(:total_from, "TotalFrom")
    property(:type, "Type")
    property(:vat_account, "VatAccount")

    def handle
      Handle.build(:name => @name)
    end
  end
end
