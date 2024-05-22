# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Fields::Type::Date do
  describe '.serialize' do
    subject(:serialize) { described_class.serialize(value) }

    [
      [nil, nil],
      [Date.new(2024, 1, 23), Date.new(2024, 1, 23)],
      [DateTime.new(2024, 1, 23, 12, 34, 56), Date.new(2024, 1, 23)]
    ].each do |actual, expected|
      context "when the value is #{actual.inspect}" do
        let(:value) { actual }

        it { is_expected.to eq(expected) }
      end
    end

    context 'when the value is a string can not be converted' do
      let(:value) { 'abc' }

      it { expect { serialize }.to raise_error(Sumaki::Model::Fields::Type::DateError) }
    end
  end

  describe '.deserialize' do
    subject { described_class.deserialize(value) }

    [
      [nil, nil],
      [Date.new(2024, 1, 23), Date.new(2024, 1, 23)],
      [DateTime.new(2024, 1, 23, 12, 34, 56), Date.new(2024, 1, 23)],
      ['abc', nil]
    ].each do |actual, expected|
      context "when the value is #{actual.inspect}" do
        let(:value) { actual }

        it { is_expected.to eq(expected) }
      end
    end
  end
end
