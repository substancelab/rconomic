module Economic
  module Support
    module SOAPActionName
      extend self

      def for_entity_with_action(entity_class, action)
        [
          class_name_without_modules(entity_class),
          action.to_s
        ].collect(&:snakecase).join("_").intern
      end

      private

      def class_name_without_modules(entity_class)
        class_name = entity_class.to_s
        class_name.split('::').last
      end
    end
  end
end
