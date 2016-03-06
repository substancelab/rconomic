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
    property(:handle, :formatter => proc { |v| v.to_hash }, :required => true)
    property(:id)
    property(:creditor_handle, :formatter => proc { |handle| handle.to_hash })
    property(:name)
    property(:number, :required => true)
    property(:telephone_number)
    property(:email)
    property(:comments)
    property(:external_id)

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

    def number
      handle.number
    end
  end
end
