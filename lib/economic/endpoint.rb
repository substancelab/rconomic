# Economic::Endpoint models the actual SOAP endpoint at E-conomic.
#
# This is where all knowledge of SOAP actions and requests exists.
class Economic::Endpoint

  # Returns the E-conomic API action name to call
  def soap_action_name(entity_class, action)
    class_name = entity_class.to_s
    class_name_without_modules = class_name.split('::').last
    "#{class_name_without_modules.snakecase}_#{action.to_s.snakecase}".intern
  end

end
