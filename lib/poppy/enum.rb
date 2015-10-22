require 'active_support/inflector'

module Poppy
  class Enum
    class << self
      def values(*values)
        self.value_keys = values
      end

      def list_values
        value_keys
      end

      def list
        value_keys.map(&method(:enum_for))
      end

      def enum_for(value_key)
        return unless valid_value_key?(value_key)
        const_get(value_key.to_s.upcase)
      end

      def collection
        value_keys.map(&method(:value_key_to_collection_item))
      end

      def const_missing(name_sym)
        name = name_sym.to_s
        if valid_class_name?(name)
          create_poppy_class(name)
        elsif valid_constant_name?(name)
          create_poppy_value(name)
        else
          super
        end
      end

      private

      attr_accessor :value_keys, :class_cache

      def value_key_to_collection_item(value_key)
        [enum_for(value_key).humanize, value_key.to_s]
      end

      def class_for_value(value)
        class_string = class_for_string_value(value)
        ActiveSupport::Inflector.constantize(class_string)
      end

      def create_poppy_class(class_name)
        const_set(class_name, Class.new.include(Poppy::Value))
      end

      def create_poppy_value(constant_name)
        const_set(constant_name, class_for_value(constant_name.downcase).new)
      end

      def valid_value_key?(value_key)
        value_keys.include?(value_key)
      end

      def valid_class_name?(class_name)
        classy?(class_name) &&
          valid_value_key?(class_name.downcase.to_sym)
      end

      def valid_constant_name?(constant_name)
        screaming_snake_case?(constant_name) &&
          valid_value_key?(constant_name.downcase.to_sym)
      end

      def classy?(string)
        ActiveSupport::Inflector.classify(string.downcase) == string
      end

      def screaming_snake_case?(string)
        ActiveSupport::Inflector.underscore(string).upcase == string
      end

      def class_for_string_value(value)
        "#{self.to_s}::#{value.to_s.capitalize}"
      end

      def value_keys
        @value_keys ||= []
      end

      def class_cache
        @class_cache ||= {}
      end
    end
  end
end
