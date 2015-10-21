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

      def enum_for(value)
        return unless enum_values.include?(value)
        class_for_value(value)
      end

      private

      attr_accessor :enum_values

      def class_for_value(value)
        class_string = class_for_string_value(value)
        ActiveSupport::Inflector.constantize(class_string)
      rescue NameError
        const_set(value.capitalize, Class.new)
      end

      def class_for_string_value(value)
        "#{self.to_s}::#{value.to_s.capitalize}"
      end

      def enum_values
        @enum_values ||= []
      end
    end
  end
end
