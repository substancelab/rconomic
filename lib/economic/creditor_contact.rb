require 'economic/entity'

module Economic

  # Represents a creditor contact.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICreditorContact.html
  #
  # Examples
  #
  #   # Find contact
  #   contact = economic.contacts.find(5)
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
      @handle ||= Handle.build({:id => @id})
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Id'] = id unless id.blank?
      data['CreditorHandle'] = { 'Number' => creditor_handle[:number] } unless creditor_handle.blank?
      data['Name'] = name unless name.blank?
      data['Number'] = handle.number
      data['TelephoneNumber'] = telephone_number unless telephone_number.blank?
      data['Email'] = email unless email.blank?
      data['Comments'] = comments unless comments.blank?
      data['ExternalId'] = external_id unless external_id.blank?

      return data
    end

  end

end
