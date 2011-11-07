class Economic::Entity
  class Handle
    attr_accessor :id, :id1, :id2, :number

    def initialize(hash)
      verify_sanity_of_arguments!(hash)

      @id = hash[:id]
      @id1 = hash[:id1]
      @id2 = hash[:id2]
      @number = hash[:number]
    end

    def to_hash
      hash = {}
      hash['Id'] = id unless id.blank?
      hash['Id1'] = id1 unless id1.blank?
      hash['Id2'] = id2 unless id2.blank?
      hash['Number'] = number unless number.blank?
      hash
    end

    def [](key)
      {:id => @id, :id1 => @id1, :id2 => @id2, :number => @number}[key]
    end

    def ==(other)
      return false if other.nil?
      return false unless other.respond_to?(:id) && other.respond_to?(:number)
      self.id == other.id && self.number == other.number
    end

  private

    # Raises exceptions if hash doesn't contain values we can use to construct a new handle
    def verify_sanity_of_arguments!(hash)
      raise ArgumentError.new("Expected Hash or Economic::Entity::Handle - got #{hash.inspect}") unless hash.respond_to?(:keys) && hash.respond_to?(:values)

      unknown_keys = hash.keys - [:id, :id1, :id2, :number]
      raise ArgumentError.new("Unknown keys in handle: #{unknown_keys.inspect}") unless unknown_keys.empty?

      not_to_iable = hash.select { |k, v| !v.respond_to?(:to_i) }
      raise ArgumentError.new("All values must respond to to_i. #{not_to_iable.inspect} didn't") unless not_to_iable.empty?
    end

  end
end
