# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sumaki::Model::Associations::Collection do
  describe '#build' do
    subject(:build) { collection.build(assoc_name: 'name') }

    let(:assoc_class) do
      Class.new do
        include Sumaki::Model

        field :assoc_name
      end
    end
    let(:owner_class) do
      klass = Class.new do
        include Sumaki::Model

        repeated :assoc
      end

      klass.const_set(:Assoc, assoc_class)
      klass
    end

    let(:collection_class) do
      reflection = Sumaki::Model::Associations::Reflection::Repeated.new(owner_class, 'assoc')
      Class.new(described_class).tap { _1.reflection = reflection }
    end

    let(:owner) { owner_class.new({}) }
    let(:collection) { collection_class.new([], owner: owner) }

    context 'when the association is empty' do
      it { is_expected.to be_a(assoc_class).and have_attributes(assoc_name: 'name') }

      it do
        build
        expect(collection).to match([an_instance_of(assoc_class).and(have_attributes(assoc_name: 'name'))])
      end

      it do
        build
        expect(owner.object).to eq({ assoc: [{ assoc_name: 'name' }] })
      end
    end

    context 'when the association has an element' do
      before do
        collection.build
      end

      it { is_expected.to be_a(assoc_class).and have_attributes(assoc_name: 'name') }

      it do # rubocop:disable RSpec/ExampleLength
        build
        expect(collection).to match(
          [
            an_instance_of(assoc_class).and(have_attributes(assoc_name: nil)),
            an_instance_of(assoc_class).and(have_attributes(assoc_name: 'name'))
          ]
        )
      end

      it do
        build
        expect(owner.object).to eq({ assoc: [{}, { assoc_name: 'name' }] })
      end
    end
  end
end
