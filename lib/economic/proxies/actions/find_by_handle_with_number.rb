# Use FindByHandleWithNumber when the SOAP action to find entity requires
# `Number` to be passed rather than the default `Id`
module FindByHandleWithNumber
  def find(handle)
    handle = if handle.respond_to?(:to_i)
      Economic::Entity::Handle.new(:number => handle.to_i)
    else
      Economic::Entity::Handle.new(handle)
    end
    super(handle)
  end
end
