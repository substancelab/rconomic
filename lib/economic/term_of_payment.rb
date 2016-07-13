require "economic/entity"

module Economic
  class TermOfPayment < Entity
    has_properties :handle,
      :id,
      :name,
      :term_of_payment_type,
      :days,
      :description,
      :contra_account_handle,
      :contra_account_2_handle,
      :debtor_handle,
      :distribution_in_percent,
      :distribution_in_percent2

    defaults(
      :distribution_in_percent => nil,
      :distribution_in_percent2 => nil
    )

    def handle
      Handle.build(:name => @name)
    end

    protected

    def fields
      [
        ["Handle", :handle, proc { |handle| handle.to_hash }, :required],
        ["Id", :id],
        ["Name", :name],
        ["TermOfPaymentType", :term_of_payment_type, to_hash, :required],
        ["Days", :days, nil, :required],
        ["Description", :description],
        ["ContraAccountHandle", :contra_account_handle, to_hash],
        ["ContraAccount2Handle", :contra_account_2_handle, to_hash],
        ["DebtorHandle", :debtor_handle, to_hash],
        ["DistributionInPercent", :distribution_in_percent, nil, :required],
        ["DistributionInPercent2", :distribution_in_percent2, nil, :required]
      ]
    end
  end
end
