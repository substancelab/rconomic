require "economic/entity"

module Economic
  class Account < Entity
    has_properties :name, :number, :balance, :block_direct_entries, :contra_account, :debit_credit, :department, :distribution_key, :is_accessible, :opening_account, :total_from, :type, :vat_account

    def handle
      Handle.build(:name => @name)
    end

    protected

    def fields
      [
        ["Handle", :handle, proc { |handle| handle.to_hash }, :required],
        ["Name", :name, nil, :required],
        ["Number", :number, nil, :required]
      ]
    end
  end
end
