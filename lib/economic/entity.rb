module Economic

  class Entity

    # Internal accessors
    attr_accessor :persisted, :session, :partial

    class << self
      def properties_not_triggering_full_load
        [:id, :number]
      end

      def has_properties(*properties)
        @properties = properties
        properties.each do |property|
          unless properties_not_triggering_full_load.include?(property) || instance_methods.include?(property.to_s)
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

      # Returns the E-conomic API action name to call
      def soap_action(action)
        class_name = self.name
        class_name_without_modules = class_name.split('::').last
        "#{class_name_without_modules.snake_case}_#{action.to_s.snake_case}".intern
      end
    end

    def initialize(values = {})
      initialize_defaults
      update_properties(values)
      @persisted = false
      @partial = true
    end

    def initialize_defaults
      nil
    end

    # Updates Entity with its data from the API
    def get_data
      response = session.request soap_action(:get_data) do
        soap.body = {
          'entityHandle' => {
            'Number' => number
          }
        }
      end
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

    def inspect
      props = self.class.properties.collect { |p| "#{p}=#{self.send(p).inspect}" }
      "#<#{self.class}:#{self.object_id} partial=#{partial?}, persisted=#{persisted?}, #{props.join(', ')}>"
    end

    # Persist the Entity to the API
    def save
      create_or_update
    end

    # Updates properties of Entity with the values from hash
    def update_properties(hash)
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
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
      response = session.request soap_action('CreateFromData') do
        soap.body = {'data' => build_soap_data}
      end

      @persisted = true
      @partial = false

      return response
    end

    def update
      response = session.request soap_action(:update_from_data) do
        soap.body = {'data' => build_soap_data}
      end

      @persisted = true
      @partial = false

      return response
    end

    # Returns OrderedHash with the data structure to send to the API
    def build_soap_data
    end

    def soap_action(action)
      self.class.soap_action(action)
    end

  end

end