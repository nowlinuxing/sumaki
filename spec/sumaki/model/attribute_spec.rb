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
    subject(:wrapped) do
      SumakiAttributeTest.new(
        {
          a: 2,
          foo: {
            b: 3
          },
          bar: [
            { c: 5 }
          ]
        }
      )
    end

    class SumakiAttributeTest
      include Sumaki::Model
      singular :foo
      repeated :bar
      field :a

      class Foo
        include Sumaki::Model
        field :b
      end

      class Bar
        include Sumaki::Model
        field :c
      end
    end

    it 'defines a method that returns a value' do
      expect(wrapped.a).to eq(2)
    end

    context 'when nested using singular' do
      it 'defines a method that returns a value' do
        expect(wrapped.foo.b).to eq(3)
      end
    end

    context 'when nested using repeated' do
      it 'defines a method that returns a value' do
        expect(wrapped.bar[0].c).to eq(5)
      end
    end

    context 'when the defined method is overrided' do
      subject(:wrapped) do
        SumakiOverrideAttributeTest.new(
          {
            a: 2,
            foo: {
              b: 3
            },
            bar: [
              { c: 5 }
            ]
          }
        )
      end

      class SumakiOverrideAttributeTest
        include Sumaki::Model
        singular :foo
        repeated :bar
        field :a

        def a
          super * 7
        end

        class Foo
          include Sumaki::Model
          field :b

          def b
            super * 11
          end
        end

        class Bar
          include Sumaki::Model
          field :c

          def c
            super * 13
          end
        end
      end

      it 'overrides the defined method' do
        expect(wrapped.a).to eq(2 * 7)
      end

      it 'overrides the defined method in the nested singular class' do
        expect(wrapped.foo.b).to eq(3 * 11)
      end

      it 'overrides the defined method in the nested repeated class' do
        expect(wrapped.bar[0].c).to eq(5 * 13)
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
