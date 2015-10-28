require 'spec_helper'

RSpec.describe Poppy::Value do
  class AValue
    include Poppy::Value
  end

  describe '#to_s' do
    pending
  end

  describe '#humanize' do
    pending
    context 'with i18n value' do
      pending
    end
  end
end
