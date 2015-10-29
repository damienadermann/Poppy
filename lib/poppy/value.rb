require 'active_support/inflector'

module Poppy
  module Value
    def humanize
      ActiveSupport::Inflector.underscore(value_name).gsub('_', ' ').capitalize
    end

    def to_s
      name_segments = self.class.name.split('::')
      name_segments[-1] = to_screaming_snake_case(name_segments[-1])
      name_segments.join('::')
    end

    private

    def to_screaming_snake_case(string)
      ActiveSupport::Inflector.underscore(string).upcase
    end

    def value_name
      ActiveSupport::Inflector.demodulize(self.class.name)
    end
  end
end
