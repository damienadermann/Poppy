require 'spec_helper'

RSpec.describe Poppy::Value do
  module A
    class TestValue
      include Poppy::Value
    end
  end

  describe '#to_s' do
    subject { A::TestValue.new.to_s }

    it { is_expected.to eq('A::TestValue') }
  end

  describe '#humanize' do
    subject { A::TestValue.new.humanize }

    it { is_expected.to eq('Test value') }

    context 'with i18n value' do
      pending
    end
  end
end
