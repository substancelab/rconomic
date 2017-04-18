require "economic/entity"

module Economic
  class TermOfPayment < Entity
    has_properties :handle,
      :id,
      :name,
      :type,
      :days,
      :description,
      :contra_account_handle,
      :contra_account_2_handle,
      :debtor_handle,
      :distribution_in_percent,
      :distribution_in_percent2

    defaults(
      :id => 0,
      :type => 'Net',
      :distribution_in_percent => nil,
      :distribution_in_percent2 => nil
    )

    def handle
      Handle.build(:id => (@id.nil? ? 0 : @id))
    end

    protected

    def fields
      to_hash = proc { |h| h.to_hash }
      [
        ["Handle", :handle, to_hash, :required],
        ["Id", :id],
        ["Name", :name],
        ["Type", :type, nil, :required],
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
