# frozen_string_literal: true

require "forwardable"

module Economic
  class EntityProxy
    class << self
      # Returns the class this Proxy is a proxy for
      def entity_class
        Economic.const_get(entity_class_name)
      end

      def entity_class_name
        proxy_class_name = name.split("::").last
        proxy_class_name.sub(/Proxy$/, "")
      end
    end

    include Enumerable

    extend Forwardable
    def_delegators :@items, :each, :empty?, :last, :size, :[]

    attr_reader :owner

    def initialize(owner)
      @owner = owner
      initialize_items
    end

    def session
      owner.session
    end

    # Fetches all entities from the API.
    def all
      response = request(:get_all)
      handles = response.values.flatten.collect { |handle| Entity::Handle.build(handle) }
      get_data_for_handles(handles)

      self
    end

    # Returns a new, unpersisted Economic::Entity that has been added to Proxy
    def build(properties = {})
      entity = self.class.entity_class.new(:session => session)

      entity.update_properties(properties)
      entity.partial = false

      append(entity)
      initialize_properties_with_values_from_owner(entity)

      entity
    end

    # Returns the class this proxy manages
    def entity_class
      self.class.entity_class
    end

    # Returns the name of the class this proxy manages
    def entity_class_name
      self.class.entity_class_name
    end

    # Fetches Entity data from API and returns an Entity initialized with that
    # data added to Proxy
    def find(handle)
      handle = build_handle(handle)
      entity_hash = get_data(handle)
      entity = build(entity_hash)
      entity.persisted = true
      entity
    end

    # Gets data for Entity from the API. Returns Hash with the response data
    def get_data(handle)
      handle = Entity::Handle.new(handle)
      entity_hash = request(:get_data, "entityHandle" => handle.to_hash)
      entity_hash
    end

    # Adds item to proxy unless item already exists in the proxy
    def append(item)
      items << item unless items.include?(item)
    end
    alias << append

    protected

    attr_reader :items

    # Wraps an Entity::Handle around a potential id_or_hash object as received
    # from the backend.
    #
    # If id_or_hash is a numeric value it'll be assumed to be an id and used as
    # such in the returned Entity::Handle.
    #
    # If id_or_hash is a Hash, it's values will be used as the keys and values
    # of the built Entity::Handle.
    def build_handle(id_or_hash)
      if id_or_hash.respond_to?(:to_i)
        Entity::Handle.new(:id => id_or_hash)
      else
        Entity::Handle.new(id_or_hash)
      end
    end

    # Fetches all data for the given handles. Returns Array with hashes of
    # entity data
    def get_data_array(handles)
      return [] unless handles && handles.any?

      entity_class_name_for_soap_request = entity_class.name.split("::").last
      response = request(:get_data_array, "entityHandles" => {"#{entity_class_name_for_soap_request}Handle" => handles.collect(&:to_hash)})
      [response["#{entity_class.key}_data".intern]].flatten
    end

    def get_data_for_handles(handles)
      if handles.size == 1
        # Fetch data for single entity
        find(handles.first.to_hash)
      elsif handles.size > 1
        # Fetch all data for all the entities
        entity_data = get_data_array(handles)

        # Build Entity objects and add them to the proxy
        entity_data.each do |data|
          entity = build(data)
          entity.persisted = true
        end
      end
    end

    # Removes all loaded items
    def initialize_items
      @items = []
    end

    # Initialize properties of entity with values from owner. Returns entity
    def initialize_properties_with_values_from_owner(entity)
      entity
    end

    # Requests an action from the API endpoint
    def request(action, data = nil)
      session.request(
        Endpoint.new.soap_action_name(entity_class, action),
        data
      )
    end
  end
end
