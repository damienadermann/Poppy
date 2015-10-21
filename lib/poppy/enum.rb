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
        ActiveSupport::Inflector.constantize(class_for_value(value))
      end

      private

      attr_accessor :enum_values

      def class_for_value(value)
        "#{self.to_s}::#{value.to_s.capitalize}"
      end

      def enum_values
        @enum_values ||= []
      end
    end
  end
end
