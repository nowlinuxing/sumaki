# frozen_string_literal: true

RSpec.describe Sumaki::Model::Fields do
  describe '.field' do
    subject(:wrapped) { klass.new({ a: 2 }) }

    let(:klass) do
      Class.new do
        include Sumaki::Model
        field :a
      end
    end

    it 'defines a method that returns a value' do
      expect(wrapped.a).to eq(2)
    end

    context 'when the defined method is overrided' do
      subject(:wrapped) { klass.new({ a: 2 }) }

      let(:klass) do
        c = super()
        c.class_eval do
          def a
            super * 7
          end
        end
        c
      end

      it 'overrides the defined method' do
        expect(wrapped.a).to eq(2 * 7)
      end
    end
  end

  describe 'getter' do
    subject { klass.new({ foo: '123' }).foo }

    let(:klass) do
      c = Class.new { include Sumaki::Model }
      c.field :foo, field_type
      c
    end

    context 'when the field type is not specified' do
      let(:field_type) { nil }

      it { is_expected.to eq('123') }
    end

    context 'when the field type is specified' do
      let(:field_type) { :int }

      it { is_expected.to eq(123) }
    end
  end

  describe 'setter' do
    subject(:set) { model.foo = '123' }

    let(:klass) do
      c = Class.new { include Sumaki::Model }
      c.field :foo, field_type
      c
    end

    let(:model) { klass.new({}) }

    context 'when the field type is not specified' do
      let(:field_type) { nil }

      it do
        set
        expect(model.object).to eq({ foo: '123' })
      end
    end

    context 'when the field type is specified' do
      let(:field_type) { :int }

      it do
        set
        expect(model.object).to eq({ foo: 123 })
      end
    end
  end

  describe '.attribute_names' do
    subject { klass.attribute_names }

    let(:klass) do
      Class.new do
        include Sumaki::Model

        field :foo
        field :bar
        field :baz
      end
    end

    it { is_expected.to eq(%i[foo bar baz]) }
  end
end
