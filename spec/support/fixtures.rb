# frozen_string_literal: true

# Returns the contents of a fixture file for operation
def fixture(operation, fixture)
  fixture_path = File.join(
    "spec/fixtures",
    operation.to_s,
    "#{fixture}.xml"
  )
  File.read(fixture_path)
end
