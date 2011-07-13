module Economic
  class EntityProxy
    class << self
      # Returns the class this Proxy is a proxy for
      def entity_class
        Entity
      end
    end

    attr_reader :owner

    def initialize(owner)
      @owner = owner
    end

    def session
      owner.session
    end

    # Returns a new, unpersisted Economic::Entity
    def build(properties = {})
      entity = self.class.entity_class.new(:session => session)

      entity.update_properties(properties)
      entity.partial = false

      entity
    end

    # Gets data for Entity from the API
    def find(number)
      entity_hash = session.request self.class.entity_class.soap_action(:get_data)  do
        soap.body = {
          'entityHandle' => {
            'Number' => number
          }
        }
      end
      entity = build(entity_hash)
      entity.persisted = true
      entity
    end
  end
end