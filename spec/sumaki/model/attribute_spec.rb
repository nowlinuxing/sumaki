# frozen_string_literal: true

RSpec.describe Sumaki::Model::Attribute do
  describe '.field_names' do
    subject { klass.field_names }

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

  describe '.field' do
    subject(:wrapped) { SumakiAttributeTest.new({ a: 2 }) }

    class SumakiAttributeTest
      include Sumaki::Model
      field :a
    end

    it 'defines a method that returns a value' do
      expect(wrapped.a).to eq(2)
    end

    context 'when the defined method is overrided' do
      subject(:wrapped) { SumakiOverrideAttributeTest.new({ a: 2 }) }

      class SumakiOverrideAttributeTest
        include Sumaki::Model
        field :a

        def a
          super * 7
        end
      end

      it 'overrides the defined method' do
        expect(wrapped.a).to eq(2 * 7)
      end
    end
  end

  describe 'getter' do
    subject { model.foo }

    let(:klass) do
      Class.new do
        include Sumaki::Model

        field :foo
      end
    end

    context "when the value doesn't exist" do
      let(:model) { klass.new({}) }

      it { is_expected.to be_nil }
    end

    context 'when the value exists' do
      let(:model) { klass.new({ foo: 'value' }) }

      it { is_expected.to eq('value') }
    end
  end

  describe 'setter' do
    subject(:set) { model.foo = 'new value' }

    let(:klass) do
      Class.new do
        include Sumaki::Model

        field :foo
      end
    end

    context "when the value doesn't exist" do
      let(:model) { klass.new({}) }

      it { is_expected.to eq('new value') }

      it do
        set
        expect(model.object).to eq({ foo: 'new value' })
      end
    end

    context 'when the value exists' do
      let(:model) { klass.new({ foo: 'old value' }) }

      it { is_expected.to eq('new value') }

      it do
        set
        expect(model.object).to eq({ foo: 'new value' })
      end
    end
  end
end
