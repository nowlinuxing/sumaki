# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Fields::Reflection do
  describe '#type_class' do
    subject { reflection.type_class }

    let(:reflection) { described_class.new(:field, type) }

    context 'when the type is :int' do
      let(:type) { :int }

      it { is_expected.to eq(Sumaki::Model::Fields::Type::Integer) }
    end

    context 'when the type is nil' do
      let(:type) { nil }

      it { is_expected.to eq(Sumaki::Model::Fields::Type::Value) }
    end
  end
end
