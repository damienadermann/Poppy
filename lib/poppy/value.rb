require 'active_support/inflector'

module Poppy
  module Value
    def humanize
      value_name.capitalize #TODO spec
    end

    private

    def value_name
      ActiveSupport::Inflector.demodulize(self.class.name)
    end
  end
end
