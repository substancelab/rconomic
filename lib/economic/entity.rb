require "economic/endpoint"
require "economic/entity/handle"
require "economic/entity/mapper"

module Economic
  class Entity
    # Internal accessors
    attr_accessor :persisted, :session, :partial

    class << self
      # Sets default property values that an entity should be initialized with
      def defaults(default_values)
        @default_values = default_values
      end

      # Returns the default values for properties
      def default_values
        @default_values || {}
      end

      # Create a setter method for property that converts its input to a Handle
      def handle_writer(property)
        define_method "#{property}=" do |value|
          value = Economic::Entity::Handle.new(value) if value
          instance_variable_set("@#{property}", value)
        end
      end

      def properties_not_triggering_full_load
        [:id, :number, :handle]
      end

      # Create a property getter that loads the full Entity from the API if
      # necessary
      def property_reader(property)
        define_method property.to_s do
          value = instance_variable_get("@#{property}")
          if value.nil? && partial? && persisted?
            instance_variable_get("@#{property}")
          else
            value
          end
        end
      end

      # Create a property setter for property
      def property_writer(property)
        if property.to_s.end_with?("_handle")
          handle_writer property
        else
          # Just use regular writers
          attr_writer property
        end
      end

      def has_properties(*properties)
        @properties = properties
        properties.each do |property|
          # Create a getter for property
          unless properties_not_triggering_full_load.include?(property)
            property_reader property
          end

          # Create a setter for property
          property_writer property
        end
      end

      def properties
        @properties || []
      end

      # Returns the class used to instantiate a proxy for Entity
      def proxy
        class_name = name.split("::").last
        proxy_class_name = "#{class_name}Proxy"
        Economic.const_get(proxy_class_name)
      end

      # Returns a symbol based on the name of the entity. Used to request and
      # read data responses.
      #
      #   Entity.key #=> :entity
      #   CurrentInvoice.key #=> :current_invoice
      def key
        key = name
        key = Economic::Support::String.demodulize(key)
        key = Economic::Support::String.underscore(key)
        key.intern
      end
    end

    def handle
      @handle || Handle.build(:number => @number, :id => @id)
    end

    def handle=(handle)
      @handle = Handle.build(handle)
    end

    def initialize(properties = {})
      initialize_defaults
      update_properties(properties)
      @persisted = false
      @partial = true
    end

    # Updates Entity with its data from the API
    def get_data
      response = proxy.get_data(handle)
      update_properties(response)
      self.partial = false
      self.persisted = true
    end

    # Get default Entity with its number from the API
    def get
      proxy.get
    end

    # Returns the number of Entity. This does not trigger a load from the API
    # even if Entity is partial
    attr_reader :number

    # Returns the id of Entity. This does not trigger a load from the API even
    # if Entity is partial
    attr_reader :id

    # Returns true if CurrentInvoiceLine has been persisted in e-conomic
    def persisted?
      !!@persisted
    end

    # Returns true if Entity has not been fully loaded from API yet
    def partial?
      # TODO: Can this be introspected somehow?
      !!@partial
    end

    # Returns a proxy for entities of the current class. For example if called
    # on an Economic::Debtor it returns an instance of Economic::DebtorProxy
    # with the Debtors session as owner.
    def proxy
      self.class.proxy.new(session)
    end

    def inspect
      props = self.class.properties.collect { |p| "#{p}=#{send(p).inspect}" }
      "#<#{self.class}:#{object_id} partial=#{partial?}, persisted=#{persisted?}, #{props.join(', ')}>"
    end

    # Persist the Entity to the API
    def save
      create_or_update
    end

    # Deletes entity permanently from E-conomic.
    def destroy
      handleKey = "#{Support::String.camel_back(class_name)}Handle"
      response = request(:delete, handleKey => handle.to_hash)

      @persisted = false
      @partial = true

      response
    end

    # Updates properties of Entity with the values from hash
    def update_properties(hash)
      hash.each do |key, value|
        setter_method = "#{key}="
        if respond_to?(setter_method)
          send(setter_method, value)
        end
      end
    end

    def ==(other)
      return false if other.nil?
      handle == other.handle && other.is_a?(self.class)
    end

    protected

    def create_or_update
      if persisted?
        update
      else
        create
      end
    end

    def create
      response = request(:create_from_data, "data" => build_soap_data)

      if response
        @number = response[:number]
        @id = response[:id]
        @id1 = response[:id1]
        @id2 = response[:id2]
      end

      @persisted = true
      @partial = false

      response
    end

    def defaults
      self.class.default_values
    end

    def update
      response = request(:update_from_data, "data" => build_soap_data)

      @persisted = true
      @partial = false

      response
    end

    # Returns Hash with the data structure to send to the API
    def build_soap_data
      Entity::Mapper.new(self, fields).to_hash
    end

    def fields
      raise NotImplementedError, "Subclasses of Economic::Entity must implement `fields`"
    end

    # Requests an action from the API endpoint
    def request(action, data = nil)
      session.request(
        Endpoint.new.soap_action_name(self.class, action),
        data
      )
    end

    def class_name
      self.class.to_s.split("::").last
    end

    def initialize_defaults
      defaults.each do |property_name, default_value|
        send("#{property_name}=", default_value)
      end
    end
  end
end
