require 'spec_helper'

RSpec.describe Poppy::Enum do
  class DummyEnum < Poppy::Enum
    values :one, :two

    class One

    end
  end

  describe '.list_values' do
    subject { DummyEnum.list_values }

    specify do
      is_expected.to eq([:one, :two])
    end
  end

  describe '.enum_for' do
    subject { DummyEnum.enum_for(value) }

    context do
      let(:value) { :invalid }
      specify { is_expected.to be_nil }
    end

    context do
      let(:value) { :one }
      specify { is_expected.to eq(DummyEnum::One) }
    end

    context do
      let(:value) { :two }
      specify { is_expected.to eq(DummyEnum::One) }
    end
  end

  describe '.list' do

  end

  describe '.collection' do

  end
end
