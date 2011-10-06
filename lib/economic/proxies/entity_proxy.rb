module Economic
  class EntityProxy
    class << self
      # Returns the class this Proxy is a proxy for
      def entity_class
        proxy_class_name = name.split('::').last
        entity_class_name = proxy_class_name.sub(/Proxy$/, '')
        Economic.const_get(entity_class_name)
      end
    end

    include Enumerable

    attr_reader :owner, :items

    def initialize(owner)
      @owner = owner
      @items = []
    end

    def session
      owner.session
    end

    # Returns a new, unpersisted Economic::Entity
    def build(properties = {})
      entity = self.class.entity_class.new(:session => session)

      entity.update_properties(properties)
      entity.partial = false

      self.append(entity)

      entity
    end

    # Returns the class this proxy manages
    def entity_class
      self.class.entity_class
    end

    # Fetches Entity data from API and returns an Entity initialized with that data
    def find(handle)
      handle = Entity::Handle.new(handle) unless handle.is_a?(Entity::Handle)
      entity_hash = get_data(handle)
      entity = build(entity_hash)
      entity.persisted = true
      entity
    end

    # Gets data for Entity from the API. Returns Hash with the response data
    def get_data(handle)
      handle = Entity::Handle.new(handle) unless handle.is_a?(Entity::Handle)

      entityHandle = {}
      entityHandle['Id'] = handle.id unless handle.id.blank?
      entityHandle['Number'] = handle.number unless handle.number.blank?
      entity_hash = session.request(entity_class.soap_action(:get_data)) do
        soap.body = {
          'entityHandle' => entityHandle
        }
      end
      entity_hash
    end

    # Adds item to proxy unless item already exists in the proxy
    def append(item)
      items << item unless items.include?(item)
    end
    alias :<< :append

    def each
      items.each { |i| yield i }
    end

    def empty?
      items.empty?
    end

    # Returns the number of entities in proxy
    def size
      items.size
    end

  end
end