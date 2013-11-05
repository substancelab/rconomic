module Economic::Mappers
  class CreditorContactMapper
    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    def to_hash
      data = {}

      data['Handle'] = entity.handle.to_hash
      data['Id'] = entity.id unless entity.id.blank?
      data['CreditorHandle'] = { 'Number' => entity.creditor_handle[:number] } unless entity.creditor_handle.blank?
      data['Name'] = entity.name unless entity.name.blank?
      data['Number'] = entity.handle.number
      data['TelephoneNumber'] = entity.telephone_number unless entity.telephone_number.blank?
      data['Email'] = entity.email unless entity.email.blank?
      data['Comments'] = entity.comments unless entity.comments.blank?
      data['ExternalId'] = entity.external_id unless entity.external_id.blank?

      return data
    end
  end
end
