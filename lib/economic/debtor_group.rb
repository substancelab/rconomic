require "economic/entity"

module Economic
  class DebtorGroup < Entity
    has_properties :handle,
      :number,
      :name,
      :account_handle,
      :layout_handle

    def handle
      Handle.build(:number => (@number.nil? ? 0 : @number))
    end

    protected

    def fields
      to_hash = proc { |h| h.to_hash }
      [
        ["Handle", :handle, to_hash],
        ["Number", :number, nil, :required],
        ["Name", :name],
        ["AccountHandle", :account_handle],
        ["LayoutHandle", :layout_handle]
      ]
    end
  end
end
