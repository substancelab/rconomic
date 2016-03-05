require "economic/entity"

module Economic
  # Represents a creditor contact.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICreditorContact.html
  #
  # Examples
  #
  #   # Find contact
  #   contact = economic.contacts.find(:id => 5)
  #
  #   # Creating a contact
  #   contact = creditor.contacts.build
  #   contact.id = 0
  #   contact.number = 0
  #   contact.name = 'John Appleseed'
  #   contact.save
  class CreditorContact < Entity
    has_properties :id, :creditor_handle, :name, :number, :telephone_number, :email, :comments, :external_id

    def creditor
      return nil if creditor_handle.nil?
      @creditor ||= session.creditors.find(creditor_handle[:number])
    end

    def creditor=(creditor)
      self.creditor_handle = creditor.handle
      @creditor = creditor
    end

    def creditor_handle=(handle)
      @creditor = nil unless handle == @creditor_handle
      @creditor_handle = handle
    end

    def handle
      @handle || Handle.build(:id => @id)
    end

    protected

    def fields
      to_hash = proc { |handle| handle.to_hash }
      # SOAP field, entity method, formatter proc, required?
      [
        ["Handle", :handle, proc { |v| v.to_hash }, :required],
        ["Id", :id, nil],
        ["CreditorHandle", :creditor_handle, to_hash],
        ["Name", :name],
        ["Number", :handle, proc { |v| v.number }, :required],
        ["TelephoneNumber", :telephone_number],
        ["Email", :email],
        ["Comments", :comments],
        ["ExternalId", :external_id]
      ]
    end
  end
end
