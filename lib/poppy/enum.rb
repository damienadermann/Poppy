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
        class_cache.fetch(value_key) do
          class_cache[value_key] = class_for_value(value_key)
        end
      end

      def collection
        value_keys.map(&method(:value_key_to_collection_item))
      end

      def const_missing(name)
        if valid_value_key?(name.downcase.to_sym)
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

      def create_poppy_value(class_name)
        const_set(class_name, Class.new.extend(Poppy::Value))
      end

      def valid_value_key?(value)
        value_keys.include?(value)
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
