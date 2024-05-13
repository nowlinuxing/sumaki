# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Associations::Association do
  let(:assoc_class) do
    Class.new do
      include Sumaki::Model
      field :field
    end
  end
  let(:owner_class) do
    klass = Class.new { include Sumaki::Model }
    klass.const_set(:Assoc, assoc_class)
    klass
  end

  describe Sumaki::Model::Associations::Association::Singular do
    let(:reflection) { Sumaki::Model::Associations::Reflection::Singular.new(owner_class, 'assoc') }
    let(:association) { described_class.new(owner, reflection) }

    describe '#model' do
      subject { association.model }

      context "when the association doesn't exist" do # rubocop:disable RSpec/NestedGroups
        let(:owner) { owner_class.new({}) }

        it { is_expected.to be_nil }
      end

      context 'when the association exists' do # rubocop:disable RSpec/NestedGroups
        let(:owner) { owner_class.new({ assoc: { field: 'field' } }) }

        it { is_expected.to be_an_instance_of(assoc_class) }
        it { is_expected.to have_attributes(field: 'field') }
        it { is_expected.to have_attributes(parent: owner) }
      end
    end

    describe '#build_model' do
      subject { association.build_model(field: 'field') }

      let(:owner) { owner_class.new({}) }

      it { is_expected.to be_an_instance_of(assoc_class) }
      it { is_expected.to have_attributes(field: 'field') }
      it { is_expected.to have_attributes(parent: owner) }
    end
  end

  describe Sumaki::Model::Associations::Association::Repeated do
    let(:reflection) { Sumaki::Model::Associations::Reflection::Repeated.new(owner_class, 'assoc') }
    let(:association) { described_class.new(owner, reflection) }

    describe '#collection' do
      subject { association.collection }

      context "when the association isn't an Array" do # rubocop:disable RSpec/NestedGroups
        let(:owner) { owner_class.new({}) }

        it { is_expected.to have_attributes(class: (a_value < Sumaki::Model::Associations::Collection)) }
        it { is_expected.to match([]) }
      end

      context 'when the association is an Array' do # rubocop:disable RSpec/NestedGroups
        let(:owner) { owner_class.new({ assoc: [{ field: 'field' }] }) }

        it { is_expected.to have_attributes(class: (a_value < Sumaki::Model::Associations::Collection)) }
        it { is_expected.to match([an_instance_of(assoc_class).and(have_attributes(field: 'field'))]) }
      end
    end
  end
end
