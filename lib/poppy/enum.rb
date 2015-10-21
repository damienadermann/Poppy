require 'active_support/inflector'

module Poppy
  class Enum
    class << self
      def values(*values)
        self.enum_values = values
      end

      def list_values
        enum_values
      end

      def list
        enum_values.map(&method(:enum_for))
      end

      def enum_for(value)
        return unless enum_values.include?(value)
        class_cache.fetch(value) do
          class_cache[value] = class_for_value(value)
        end
      end

      def const_missing(name)
        create_poppy_value(name)
      end

      private

      attr_accessor :enum_values, :class_cache

      def class_for_value(value)
        class_string = class_for_string_value(value)
        ActiveSupport::Inflector.constantize(class_string)
      end

      def create_poppy_value(class_name)
        const_set(class_name, Class.new.extend(Poppy::Value))
      end

      def class_for_string_value(value)
        "#{self.to_s}::#{value.to_s.capitalize}"
      end

      def enum_values
        @enum_values ||= []
      end

      def class_cache
        @class_cache ||= {}
      end
    end
  end
end
