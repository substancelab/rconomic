module Economic::Mappers
  class DebtorContactMapper
    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    def to_hash
      data = {}

      fields.each do |field, method, formatter, required|
        value = entity.send(method)
        present = present?(value)

        if present || required
          value = formatter.call(value) if formatter
          data[field] = value
        end
      end

      return data
    end

    private

    def fields
      # SOAP field, entity method, formatter proc, required?
      [
        ["Handle", :handle, Proc.new { |v| v.to_hash }, :required],
        ["Id", :handle, Proc.new { |v| v.id }, :required],
        ["DebtorHandle", :debtor, Proc.new { |v| v.handle.to_hash }],
        ["Name", :name, nil, :required],
        ["Number", :handle, Proc.new { |v| v.number }],
        ["TelephoneNumber", :telephone_number],
        ["Email", :email],
        ["Comments", :comments],
        ["ExternalId", :external_id],
        ["IsToReceiveEmailCopyOfOrder", :is_to_receive_email_copy_of_order, Proc.new { |v| v || false }, :required],
        ["IsToReceiveEmailCopyOfInvoice", :is_to_receive_email_copy_of_invoice, Proc.new { |v| v || false }, :required]
      ]
    end

    def present?(value)
      !(
        (value.respond_to?(:blank?) && value.blank?) ||
        (value.respond_to?(:empty?) && value.empty?)
      )
    end
  end
end
