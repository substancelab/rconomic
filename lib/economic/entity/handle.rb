class Economic::Entity
  class Handle
    attr_accessor :id, :id1, :id2, :number, :serial_number

    def self.build(options)
      return options if options.is_a?(Handle)
      return nil if options.nil?
      new(options)
    end

    # Returns true if Handle hasn't been initialized with any values yet. This
    # usually happens when the handle is constructed for an entity whose id
    # properties (id, number, etc) haven't been set yet.
    def empty?
      to_hash.empty?
    end

    def initialize(hash)
      verify_sanity_of_arguments!(hash)
      hash = prepare_hash_argument(hash) unless hash.is_a?(self.class)

      @id = hash[:id].to_i if hash[:id]
      @id1 = hash[:id1].to_i if hash[:id1]
      @id2 = hash[:id2].to_i if hash[:id2]
      @number = hash[:number].to_i if hash[:number]
      @serial_number = hash[:serial_number].to_i if hash[:serial_number]
    end

    def to_hash(only_keys = id_properties.keys)
      only_keys = [only_keys].flatten
      hash = {}
      hash['Id'] = id if only_keys.include?(:id) && !id.blank?
      hash['Id1'] = id1 unless id1.blank? if only_keys.include?(:id1)
      hash['Id2'] = id2 unless id2.blank? if only_keys.include?(:id2)
      hash['Number'] = number unless number.blank? if only_keys.include?(:number)
      hash['SerialNumber'] = serial_number unless serial_number.blank? if only_keys.include?(:serial_number)
      hash
    end

    def [](key)
      {:id => @id, :id1 => @id1, :id2 => @id2, :number => @number, :serial_number => @serial_number}[key]
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
      {:id => 'Id', :id1 => 'Id1', :id2 => 'Id2', :number => 'Number', :serial_number => 'SerialNumber'}
    end

    # Raises exceptions if hash doesn't contain values we can use to construct a new handle
    def verify_sanity_of_arguments!(hash)
      return if hash.is_a?(self.class)

      if hash.nil? || (!hash.respond_to?(:to_i) && (!hash.respond_to?(:keys) && !hash.respond_to?(:values)))
        raise ArgumentError.new("Expected Number, Hash or Economic::Entity::Handle - got #{hash.inspect}")
      end

      if hash.respond_to?(:keys)
        unknown_keys = hash.keys - id_properties.keys - id_properties.values
        raise ArgumentError.new("Unknown keys in handle: #{unknown_keys.inspect}") unless unknown_keys.empty?

        not_to_iable = hash.select { |k, v| !v.respond_to?(:to_i) }
        raise ArgumentError.new("All values must respond to to_i. #{not_to_iable.inspect} didn't") unless not_to_iable.empty?
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
