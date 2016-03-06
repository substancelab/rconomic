module Economic
  class Entity
    module Properties
      # Utilities for formatting various data types to SOAP fields
      module Formatters
        HANDLE = proc { |handle| handle.to_hash }
      end
    end
  end
end
