require "economic/entity"

module Economic
  class Account < Entity
    property(:handle, :serialize => "Handle", :formatter => proc { |handle| handle.to_hash }, :required => true)
    property(:name, :serialize => "Name", :required => true)
    property(:number, :serialize => "Number", :required => true)
    property(:balance, :serialize => "Balance")
    property(:block_direct_entries, :serialize => "BlockDirectEntries")
    property(:contra_account, :serialize => "ContraAccount")
    property(:debit_credit, :serialize => "DebitCredit")
    property(:department, :serialize => "Department")
    property(:distribution_key, :serialize => "DistributionKey")
    property(:is_accessible, :serialize => "IsAccessible")
    property(:opening_account, :serialize => "OpeningAccount")
    property(:total_from, :serialize => "TotalFrom")
    property(:type, :serialize => "Type")
    property(:vat_account, :serialize => "VatAccount")

    def handle
      Handle.build(:name => @name)
    end

    protected

    def fields
      self.class.properties.map do |name|
        field = self.class.property_definitions[name]
        [
          field.fetch(:serialize),
          name,
          field[:formatter],
          (field[:required] ? :required : nil)
        ]
      end
    end
  end
end
