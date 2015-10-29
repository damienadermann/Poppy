require 'spec_helper'

class DummyEnum < Poppy::Enum
  values :one, :two

  class One
    include Poppy::Value
  end
end

class DummyEnum2 < Poppy::Enum
  values :one
end

RSpec.describe Poppy::Enum do

  describe '.list_keys' do
    subject { DummyEnum.list_keys }

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
      it { is_expected.to eq(DummyEnum::ONE) }
      it { is_expected.to be_instance_of(DummyEnum::One) }
    end

    context 'with inexplicitly defined class' do
      let(:value) { :two }
      it { is_expected.to eq(DummyEnum::TWO) }
      specify 'is a Poppy::Value' do
        expect(subject).to be_kind_of(Poppy::Value)
      end
    end
  end

  describe '.list' do
    subject { DummyEnum.list }
    it { is_expected.to eq([DummyEnum::ONE, DummyEnum::TWO])}
  end

  describe '.collection' do
    subject { DummyEnum.collection }
    it { is_expected.to match_array([['One', 'one'], ['Two', 'two']]) }
  end

  describe '.valid?' do
    context 'valid' do
      subject { DummyEnum.valid?(DummyEnum::ONE) }

      it { is_expected.to be_truthy }
    end
    context 'invalid' do
      subject { DummyEnum.valid?(DummyEnum2::ONE) }

      it { is_expected.to be_falsey }
    end
  end

  describe '.key_for' do
    context 'with existing key' do
      subject { DummyEnum.key_for(DummyEnum::ONE) }
      it { is_expected.to eq(:one) }
    end

    context 'with non-existing key' do
      subject { DummyEnum.key_for('wrong') }
      it { is_expected.to be_nil }
    end
  end

  describe 'can call inexplicitly defined constants' do
    specify { expect(DummyEnum2::One).to be_a(Class) }
    specify { expect{ DummyEnum2::Wrong }.to raise_error(NameError)}
  end
end
