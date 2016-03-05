module Economic
  module Support
    module String
      def self.camel_back(name)
        name[0, 1].downcase + name[1..-1]
      end

      def self.demodulize(class_name_in_module)
        class_name_in_module.to_s.gsub(/^.*::/, "")
      end

      def self.underscore(camel_cased_word)
        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, "/")
        word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end

      def self.snakecase(word)
        # Use the method from Savon::CoreExt::String.snakecase
        word.snakecase
      end
    end
  end
end
