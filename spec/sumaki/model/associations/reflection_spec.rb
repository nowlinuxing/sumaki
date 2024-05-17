# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Associations::Reflection do
  let(:assoc_class) { Class.new { include Sumaki::Model } }
  let(:owner_class) do
    klass = Class.new { include Sumaki::Model }
    klass.const_set(:Assoc, assoc_class)
    klass
  end

  describe Sumaki::Model::Associations::Reflection::Singular do
    describe '#model_class' do
      subject { reflection.model_class }

      let(:reflection) { described_class.new(owner_class, :assoc, class_name: class_name) }

      context 'when classname is not specified' do # rubocop:disable RSpec/NestedGroups
        let(:class_name) { nil }

        it { is_expected.to eq(assoc_class) }
        it { is_expected.to have_attributes(parent: owner_class) }
      end

      context 'when classname is specified' do # rubocop:disable RSpec/NestedGroups
        let(:class_name) { 'Relation' }

        it { is_expected.to have_attributes(name: "#{owner_class}::Relation") }
        it { is_expected.to have_attributes(parent: owner_class) }
      end
    end
  end

  describe Sumaki::Model::Associations::Reflection::Repeated do
    let(:reflection) { described_class.new(owner_class, :assoc, class_name: class_name) }

    describe '#model_class' do
      subject { reflection.model_class }

      context 'when classname is not specified' do # rubocop:disable RSpec/NestedGroups
        let(:class_name) { nil }

        it { is_expected.to eq(assoc_class) }
        it { is_expected.to have_attributes(parent: owner_class) }
      end

      context 'when classname is specified' do # rubocop:disable RSpec/NestedGroups
        let(:class_name) { 'Relation' }

        it { is_expected.to have_attributes(name: "#{owner_class}::Relation") }
        it { is_expected.to have_attributes(parent: owner_class) }
      end
    end

    describe '#collection_class' do
      subject { reflection.collection_class }

      context 'when class_name is not specified' do # rubocop:disable RSpec/NestedGroups
        let(:class_name) { nil }

        it { is_expected.to be < Sumaki::Model::Associations::Collection }
        it { is_expected.to have_attributes(name: "#{owner_class}::AssocCollection") }
        it { is_expected.to have_attributes(reflection: reflection) }
      end

      context 'when class_name is specified' do # rubocop:disable RSpec/NestedGroups
        let(:class_name) { 'Relation' }

        it { is_expected.to be < Sumaki::Model::Associations::Collection }
        it { is_expected.to have_attributes(name: "#{owner_class}::RelationCollection") }
        it { is_expected.to have_attributes(reflection: reflection) }
      end
    end
  end
end
