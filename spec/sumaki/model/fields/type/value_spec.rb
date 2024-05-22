# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Fields::Type::Value do
  describe '.serialize' do
    subject { described_class.serialize(:a_value) }

    it { is_expected.to eq(:a_value) }
  end

  describe '.deserialize' do
    subject { described_class.deserialize(:a_value) }

    it { is_expected.to eq(:a_value) }
  end
end
