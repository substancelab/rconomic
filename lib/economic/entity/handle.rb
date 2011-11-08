class Economic::Entity
  class Handle
    attr_accessor :id, :number

    def initialize(hash)
      verify_sanity_of_arguments!(hash)
      hash = prepare_hash_argument(hash) unless hash.is_a?(self.class)

      @id = hash[:id].to_i if hash[:id]
      @number = hash[:number].to_i if hash[:number]
    end

    def to_hash
      hash = {}
      hash['Id'] = id unless id.blank?
      hash['Number'] = number unless number.blank?
      hash
    end

    def [](key)
      {:id => @id, :number => @number}[key]
    end

    def ==(other)
      return false if other.nil?
      return false unless other.respond_to?(:id) && other.respond_to?(:number)
      self.id == other.id && self.number == other.number
    end

  private

    # Raises exceptions if hash doesn't contain values we can use to construct a new handle
    def verify_sanity_of_arguments!(hash)
      return if hash.is_a?(self.class)

      if hash.nil? || (!hash.respond_to?(:to_i) && (!hash.respond_to?(:keys) && !hash.respond_to?(:values)))
        raise ArgumentError.new("Expected Number, Hash or Economic::Entity::Handle - got #{hash.inspect}")
      end

      if hash.respond_to?(:keys)
        unknown_keys = hash.keys - [:id, :number, "Number", "Id"]
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
