require 'active_support/inflector'

module Poppy
  module Value
    def humanize
      ActiveSupport::Inflector.underscore(value_name).gsub('_', ' ').capitalize
    end

    def to_s
      self.class.name
    end

    private

    def value_name
      ActiveSupport::Inflector.demodulize(self.class.name)
    end
  end
end
