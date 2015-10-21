require 'spec_helper'

class DummyEnum < Poppy::Enum
  values :one, :two

  class One
    extend Poppy::Value

  end
end

class DummyEnum2 < Poppy::Enum
  values :one
end

RSpec.describe Poppy::Enum do

  describe '.list_values' do
    subject { DummyEnum.list_values }

    it { is_expected.to eq([:one, :two]) }
  end

  describe '.enum_for' do
    subject { DummyEnum.enum_for(value) }

    context 'invalid enum' do
      let(:value) { :invalid }
      specify { is_expected.to be_nil }
    end

    context 'valid enum' do
      let(:value) { :one }
      it { is_expected.to eq(DummyEnum::One) }
    end

    context 'with inexplicitly defined class' do
      let(:value) { :two }
      it { is_expected.to eq(DummyEnum::Two) }
      specify 'is a Poppy::Value' do
        expect(subject).to be_a(Poppy::Value)
      end
    end
  end

  describe '.list' do
    subject { DummyEnum.list }
    it { is_expected.to eq([DummyEnum::One, DummyEnum::Two])}
  end

  describe '.collection' do
    subject { DummyEnum.collection }
    it { is_expected.to match_array([['One', 'one'], ['Two', 'two']]) }
  end

  describe 'can call inexplicitly defined constants' do
    specify { expect(DummyEnum2::One).to be_a(Class) }
    specify { expect{ DummyEnum2::Wrong }.to raise_error(NameError)}
  end
end
