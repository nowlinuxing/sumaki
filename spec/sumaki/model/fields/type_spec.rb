# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Fields::Type do
  describe '.lookup' do
    subject { described_class.lookup(type_name) }

    [
      [:int, Sumaki::Model::Fields::Type::Integer],
      [:float, Sumaki::Model::Fields::Type::Float],
      [:string, Sumaki::Model::Fields::Type::String],
      [:bool, Sumaki::Model::Fields::Type::Boolean],
      [:date, Sumaki::Model::Fields::Type::Date],
      [:datetime, Sumaki::Model::Fields::Type::DateTime]
    ].each do |actual, expected|
      context "when #{actual.inspect} is specified" do
        let(:type_name) { actual }

        it { is_expected.to eq(expected) }
      end
    end
  end
end
