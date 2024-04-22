# frozen_string_literal: true

RSpec.describe Sumaki::Model::Association do
  describe '.singular' do
    subject(:wrapped) do
      SumakiSingularTest.new(
        {
          foo: {
            bar: {}
          }
        }
      )
    end

    class SumakiSingularTest
      include Sumaki::Model
      singular :foo

      class Foo
        include Sumaki::Model
        singular :bar

        class Bar
          include Sumaki::Model
        end
      end
    end

    it 'defines a method that returns an instance of the class' do
      expect(wrapped.foo).to be_a(SumakiSingularTest::Foo)
    end

    it 'sets the parent to the instance returned by the method it defines' do
      expect(wrapped.foo.parent).to be_a(SumakiSingularTest)
    end

    context 'when nested' do
      it 'defines a method that returns an instance of the class' do
        expect(wrapped.foo.bar).to be_a(SumakiSingularTest::Foo::Bar)
      end

      it 'sets the parent to the instance returned by the method it defines' do
        expect(wrapped.foo.bar.parent).to be_a(SumakiSingularTest::Foo)
      end
    end

    context 'when class_name is specified' do
      subject(:wrapped) do
        SumakiClassNameSpecifiedSingularTest.new({ foo: {} })
      end

      class SumakiClassNameSpecifiedSingularTest
        include Sumaki::Model
        singular :foo, class_name: 'Bar'

        class Bar
          include Sumaki::Model
        end
      end

      it 'defines a method that returns an instance of the specified class' do
        expect(wrapped.foo).to be_a(SumakiClassNameSpecifiedSingularTest::Bar)
      end
    end

    context 'when the defined method is overrided' do
      subject(:wrapped) do
        SumakiOverrideSingularTest.new(
          {
            foo: {
              bar: {}
            }
          }
        )
      end

      class SumakiOverrideSingularTest
        include Sumaki::Model
        singular :foo

        def foo
          { foo: super }
        end

        class Foo
          include Sumaki::Model
          singular :bar

          def bar
            { bar: super }
          end

          class Bar
            include Sumaki::Model
          end
        end
      end

      it 'overrides the defined method' do
        expect(wrapped.foo).to match({ foo: be_a(SumakiOverrideSingularTest::Foo) })
      end

      it 'overrides the defined method in the nested class' do
        expect(wrapped.foo[:foo].bar).to match({ bar: be_a(SumakiOverrideSingularTest::Foo::Bar) })
      end
    end
  end

  describe '.repeated' do
    subject(:wrapped) do
      SumakiRepeatedTest.new(
        {
          foo: [
            { bar: [{}, {}] },
            { bar: [{}, {}] }
          ]
        }
      )
    end

    class SumakiRepeatedTest
      include Sumaki::Model
      repeated :foo

      class Foo
        include Sumaki::Model
        repeated :bar

        class Bar
          include Sumaki::Model
        end
      end
    end

    it 'defines a method that returns an array of instances of the class' do
      expect(wrapped.foo).to contain_exactly(be_a(SumakiRepeatedTest::Foo), be_a(SumakiRepeatedTest::Foo))
    end

    it 'sets the parent to the instances returned by the method it defines' do
      expect(wrapped.foo[0].parent).to be_a(SumakiRepeatedTest)
    end

    context 'when nested' do
      it 'defines a method that returns an array of instances of the class' do
        expect(wrapped.foo[0].bar).to contain_exactly(be_a(SumakiRepeatedTest::Foo::Bar),
                                                      be_a(SumakiRepeatedTest::Foo::Bar))
      end

      it 'sets the parent to the instances returned by the method it defines' do
        expect(wrapped.foo[0].bar[0].parent).to be_a(SumakiRepeatedTest::Foo)
      end
    end

    context 'when class_name is specified' do
      subject(:wrapped) do
        SumakiClassNameSpecifiedRepeatedTest.new({ foo: [{}] })
      end

      class SumakiClassNameSpecifiedRepeatedTest
        include Sumaki::Model
        repeated :foo, class_name: 'Bar'

        class Bar
          include Sumaki::Model
        end
      end

      it 'defines a method that returns an instance of the specified class' do
        expect(wrapped.foo).to match([be_a(SumakiClassNameSpecifiedRepeatedTest::Bar)])
      end
    end

    context 'when the defined method is overrided' do
      subject(:wrapped) do
        SumakiOverrideRepeatedTest.new(
          {
            foo: [
              {
                bar: [
                  {}
                ]
              }
            ]
          }
        )
      end

      class SumakiOverrideRepeatedTest
        include Sumaki::Model
        repeated :foo

        def foo
          super.map.with_index(1).with_object({}) { |(e, i), r| r[i] = e }
        end

        class Foo
          include Sumaki::Model
          repeated :bar

          def bar
            super.map.with_index(1).with_object({}) { |(e, i), r| r[i] = e }
          end

          class Bar
            include Sumaki::Model
          end
        end
      end

      it 'overrides the defined method' do
        expect(wrapped.foo).to match({ 1 => be_a(SumakiOverrideRepeatedTest::Foo) })
      end

      it 'overrides the defined method in the nested class' do
        expect(wrapped.foo[1].bar).to match({ 1 => be_a(SumakiOverrideRepeatedTest::Foo::Bar) })
      end
    end
  end
end
