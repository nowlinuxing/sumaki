# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Fields::Type::Integer do
  describe '.serialize' do
    subject(:serialize) { described_class.serialize(value) }

    [
      [nil, nil],
      [123, 123],
      ['123', 123]
    ].each do |actual, expected|
      context "when the value is #{actual.inspect}" do
        let(:value) { actual }

        it { is_expected.to eq(expected) }
      end
    end

    context 'when the value is a string can not be converted' do
      let(:value) { 'abc' }

      it { expect { serialize }.to raise_error(Sumaki::Model::Fields::Type::ArgumentError) }
    end
  end

  describe '.deserialize' do
    subject { described_class.deserialize(value) }

    [
      [nil, nil],
      [123, 123],
      ['123', 123],
      ['abc', nil]
    ].each do |actual, expected|
      context "when the value is #{actual.inspect}" do
        let(:value) { actual }

        it { is_expected.to eq(expected) }
      end
    end
  end
end
