# frozen_string_literal: true

RSpec.describe Sumaki::Model::Attribute do
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
end
