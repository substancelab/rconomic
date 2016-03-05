module Economic
  # Entity::Mapper provides a generic way of building SOAP data structures for
  # entities.
  #
  # Based on an Entity and a set of rules that define the fields to map to, it
  # returns a Hash named and ordered properly, ready for passing to the
  # endpoint as SOAP data.
  class Entity::Mapper
    attr_reader :entity, :fields

    def initialize(entity, fields = [])
      @entity = entity
      @fields = fields
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

      data
    end

    private

    def present?(value)
      !(
        (value.respond_to?(:blank?) && value.blank?) ||
        (value.respond_to?(:empty?) && value.empty?)
      )
    end
  end
end
