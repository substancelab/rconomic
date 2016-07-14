require "economic/entity"

module Economic
  class TemplateCollection < Entity
    has_properties :id,
      :handle,
      :name

    def handle
      Handle.build(:id => (@id.nil? ? 0 : @id))
    end

    def save
      raise(
        NoMethodError,
        "SOAP client does not implement _CreateFromData for entity: 'TemplateCollection'"
      )
    end

    protected

    def fields
      to_hash = proc { |h| h.to_hash }
      [
        ["Handle", :handle, to_hash],
        ["Id", :id],
        ["Name", :name]
      ]
    end
  end
end
