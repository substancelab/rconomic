require "economic/entity"

module Economic
  class DebtorGroup < Entity
    has_properties :handle,
      :number,
      :name,
      :account_handle,
      :layout_handle

    def handle
      Handle.build(:number => @number)
    end

    protected

    def fields
      to_hash = proc { |h| h.to_hash }
      [
        ["Handle", :handle, to_hash],
        ["Number", :number, nil, :required],
        ["Name", :name],
        ["AccountHandle", :account_handle, to_hash, :required],
        ["LayoutHandle", :layout_handle, to_hash]
      ]
    end
  end
end
