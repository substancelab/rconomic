module Economic
  class Entity
    module Properties
      # Utilities for formatting various data types to SOAP fields
      module Formatters
        DATE = proc { |date| date.respond_to?(:iso8601) ? date.iso8601 : nil }
        HANDLE = proc { |handle| handle.to_hash }
      end
    end
  end
end
