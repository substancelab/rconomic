module Economic::Mappers
  class CreditorContactMapper
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
        ["Id", :id, nil],
        ["CreditorHandle", :creditor_handle, Proc.new {|v| {"Number" => v[:number]}}],
        ["Name", :name],
        ["Number", :handle, Proc.new { |v| v.number }, :required],
        ["TelephoneNumber", :telephone_number],
        ["Email", :email],
        ["Comments", :comments],
        ["ExternalId", :external_id]
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
