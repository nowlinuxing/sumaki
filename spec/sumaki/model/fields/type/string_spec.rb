# frozen_string_literal: true

require 'spec_helper'
require 'sumaki/model/fields/type/string'

RSpec.describe Sumaki::Model::Fields::Type::String do
  describe '.serialize' do
    subject { described_class.serialize(value) }

    [
      [nil, nil],
      %w[abc abc],
      [123, '123']
    ].each do |actual, expected|
      context "when the value is #{actual.inspect}" do
        let(:value) { actual }

        it { is_expected.to eq(expected) }
      end
    end
  end

  describe '.deserialize' do
    subject { described_class.deserialize(value) }

    [
      [nil, nil],
      %w[abc abc],
      [123, '123']
    ].each do |actual, expected|
      context "when the value is #{actual.inspect}" do
        let(:value) { actual }

        it { is_expected.to eq(expected) }
      end
    end
  end
end
