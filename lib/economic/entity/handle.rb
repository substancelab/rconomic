class Economic::Entity
  class Handle
    def self.build(options)
      return options if options.is_a?(Handle)
      return nil if options.nil?
      new(options)
    end

    def self.id_properties
      {
        :code => 'Code',
        :id => 'Id',
        :id1 => 'Id1',
        :id2 => 'Id2',
        :name => 'Name',
        :number => 'Number',
        :serial_number => 'SerialNumber',
        :vat_code => 'VatCode'
      }
    end

    def self.supported_keys
      id_properties.keys
    end

    attr_accessor *supported_keys

    # Returns true if Handle hasn't been initialized with any values yet. This
    # usually happens when the handle is constructed for an entity whose id
    # properties (id, number, etc) haven't been set yet.
    def empty?
      to_hash.empty?
    end

    def initialize(hash)
      verify_sanity_of_arguments!(hash)
      hash = prepare_hash_argument(hash) unless hash.is_a?(self.class)

      [:code, :name, :vat_code, :number].each do |key|
        instance_variable_set("@#{key}", hash[key]) if hash[key]
      end
      [:id, :id1, :id2, :serial_number].each do |key|
        instance_variable_set("@#{key}", hash[key].to_i) if hash[key]
      end
    end

    def to_hash(only_keys = id_properties.keys)
      only_keys = [only_keys].flatten
      only_keys.each_with_object({}) do |key, hash|
        property = id_properties[key]
        value = self.send(key)
        next if value.blank?
        hash[property] = value
      end
    end

    def [](key)
      instance_variable_get("@#{key}")
    end

    def ==(other)
      return true if self.object_id == other.object_id
      return false if other.nil?
      return false if empty? || (other.respond_to?(:empty?) && other.empty?)
      return false unless other.respond_to?(:id) && other.respond_to?(:number)
      self.id == other.id && self.number == other.number && self.id1 == other.id1 && self.id2 == other.id2
    end

    private

    def id_properties
      self.class.id_properties
    end

    # Raises exceptions if hash doesn't contain values we can use to construct a
    # new handle
    def verify_sanity_of_arguments!(hash)
      return if hash.is_a?(self.class)

      if hash.nil? || (!hash.respond_to?(:to_i) && (!hash.respond_to?(:keys) && !hash.respond_to?(:values)))
        raise ArgumentError.new("Expected Number, Hash or Economic::Entity::Handle - got #{hash.inspect}")
      end

      if hash.respond_to?(:keys)
        unknown_keys = hash.keys - id_properties.keys - id_properties.values
        raise ArgumentError.new("Unknown keys in handle: #{unknown_keys.inspect}") unless unknown_keys.empty?
      end
    end

    # Examples
    #
    #   prepare_hash_argument(12) #=> {:id => 12}
    #   prepare_hash_argument(:id => 12) #=> {:id => 12}
    #   prepare_hash_argument('Id' => 12) #=> {:id => 12}
    #   prepare_hash_argument('Id' => 12, 'Number' => 13) #=> {:id => 12, :number => 13}
    def prepare_hash_argument(hash)
      hash = {:id => hash.to_i} if hash.respond_to?(:to_i) unless hash.blank?
      hash[:id] ||= hash['Id']
      hash[:number] ||= hash['Number']
      hash
    end
  end
end
