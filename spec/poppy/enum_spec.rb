require 'spec_helper'

class DummyEnum < Poppy::Enum
  values :one, :two

  class One

  end
end

class DummyEnum2 < Poppy::Enum
  values :one
end

RSpec.describe Poppy::Enum do

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

    context 'with inexplicitly defined class' do
      let(:value) { :two }
      specify { is_expected.to eq(DummyEnum::Two) }
      specify 'is a Poppy::Value' do
        expect(subject).to be_a(Poppy::Value)
      end
    end
  end

  describe '.list' do
    subject { DummyEnum.list }
    specify { is_expected.to eq([DummyEnum::One, DummyEnum::Two])}
  end

  describe '.collection' do
    pending
  end

  describe 'can define inexplicitly defined constants' do
    specify { expect(DummyEnum2::Two).to be_a(Class) }
  end
end
