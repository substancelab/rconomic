require 'economic/entity'

module Economic

  # Represents a debtor contact.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_IDebtorContact.html
  #
  # Examples
  #
  #   # Find contact
  #   contact = economic.contacts.find(5)
  #
  #   # Creating a contact
  #   contact = debtor.contacts.build
  #   contact.id = 0
  #   contact.number = 0
  #   contact.name = 'John Appleseed'
  #   contact.save
  class DebtorContact < Entity
    has_properties :handle, :id, :debtor_handle, :name, :number, :telephone_number, :email, :comments, :external_id, :is_to_receive_email_copy_of_order, :is_to_receive_email_copy_of_invoice

    def debtor
      return nil if debtor_handle.blank?
      @debtor ||= session.debtors.find(debtor_handle)
    end

    def debtor=(debtor)
      self.debtor_handle = debtor.handle
      @debtor = debtor
    end

    def debtor_handle=(handle)
      @debtor = nil unless handle == @debtor_handle
      @debtor_handle = handle
    end

    def handle
      Handle.new({:id => @id})
    end

    protected

    def build_soap_data
      data = ActiveSupport::OrderedHash.new

      data['Handle'] = handle.to_hash
      data['Id'] = handle.id
      data['DebtorHandle'] = debtor.handle.to_hash unless debtor.blank?
      data['Name'] = name
      data['Number'] = number unless number.blank?
      data['TelephoneNumber'] = telephone_number unless telephone_number.blank?
      data['Email'] = email unless email.blank?
      data['Comments'] = comments unless comments.blank?
      data['ExternalId'] = external_id unless external_id.blank?
      data['IsToReceiveEmailCopyOfOrder'] = is_to_receive_email_copy_of_order || false
      data['IsToReceiveEmailCopyOfInvoice'] = is_to_receive_email_copy_of_invoice || false

      return data
    end

  end

end