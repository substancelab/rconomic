require 'economic/entity/handle'

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

      def properties_not_triggering_full_load
        [:id, :number, :handle]
      end

      def has_properties(*properties)
        @properties = properties
        properties.each do |property|
          unless properties_not_triggering_full_load.include?(property)
            # Create property accessors that loads the full Entity from the API if necessary
            define_method "#{property}" do
              value = instance_variable_get("@#{property}")
              if value.nil? && partial? && persisted?
                instance_variable_get("@#{property}")
              else
                value
              end
            end
          end

          # Just use regular writers
          attr_writer property
        end
      end

      def properties
        @properties || []
      end

      # Returns the class used to instantiate a proxy for Entity
      def proxy
        class_name = name.split('::').last
        proxy_class_name = "#{class_name}Proxy"
        Economic.const_get(proxy_class_name)
      end

      # Returns the E-conomic API action name to call
      def soap_action_name(action)
        class_name = self.name
        class_name_without_modules = class_name.split('::').last
        "#{class_name_without_modules.snakecase}_#{action.to_s.snakecase}".intern
      end

      # Returns a symbol based on the name of the entity. Used to request and read data responses.
      #
      #   Entity.key #=> :entity
      #   CurrentInvoice.key #=> :current_invoice
      def key
        key = self.name
        key = Economic::Support::String.demodulize(key)
        key = Economic::Support::String.underscore(key)
        key.intern
      end
    end

    def handle
      @handle ||= Handle.build({:number => @number, :id => @id})
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
      self.update_properties(response)
      self.partial = false
      self.persisted = true
    end
    
    # Returns the number of Entity. This does not trigger a load from the API even if Entity is partial
    def number
      @number
    end

    # Returns the id of Entity. This does not trigger a load from the API even if Entity is partial
    def id
      @id
    end

    # Returns true if CurrentInvoiceLine has been persisted in e-conomic
    def persisted?
      !!@persisted
    end

    # Returns true if Entity has not been fully loaded from API yet
    def partial?
      # TODO: Can this be introspected somehow?
      !!@partial
    end

    # Returns a proxy for entities of the current class. For example if called on an
    # Economic::Debtor it returns an instance of Economic::DebtorProxy with the Debtors session as
    # owner.
    def proxy
      self.class.proxy.new(session)
    end

    def inspect
      props = self.class.properties.collect { |p| "#{p}=#{self.send(p).inspect}" }
      "#<#{self.class}:#{self.object_id} partial=#{partial?}, persisted=#{persisted?}, #{props.join(', ')}>"
    end

    # Persist the Entity to the API
    def save
      create_or_update
    end

    # Deletes entity permanently from E-conomic.
    def destroy
      handleKey = "#{Support::String.camel_back(class_name)}Handle"
      response = request(:delete, {handleKey => handle.to_hash})

      @persisted = false
      @partial = true

      response
    end

    # Updates properties of Entity with the values from hash
    def update_properties(hash)
      hash.each do |key, value|
        setter_method = "#{key}="
        if self.respond_to?(setter_method)
          self.send(setter_method, value)
        end
      end
    end

    def ==(other)
      return false if other.nil?
      self.handle == other.handle && other.is_a?(self.class)
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
      response = request(:create_from_data, {
        'data' => build_soap_data
      })

      if response
        @number = response[:number]
        @id = response[:id]
        @id1 = response[:id1]
        @id2 = response[:id2]
      end

      @persisted = true
      @partial = false

      return response
    end

    def defaults
      self.class.default_values
    end

    def update
      response = request(:update_from_data, {
        'data' => build_soap_data
      })

      @persisted = true
      @partial = false

      return response
    end

    # Returns Hash with the data structure to send to the API
    def build_soap_data
      raise NotImplementedError, "Subclasses of Economic::Entity must implement `build_soap_data`"
    end

    # Requests an action from the API endpoint
    def request(action, data = nil)
      session.request(soap_action_name(action)) do
        soap.body = data if data
      end
    end

    def soap_action_name(action)
      self.class.soap_action_name(action)
    end

    def class_name
      self.class.to_s.split("::").last
    end

    def initialize_defaults
      defaults.each do |property_name, default_value|
        self.send("#{property_name}=", default_value)
      end
    end
  end

end
