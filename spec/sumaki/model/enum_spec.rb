# frozen_string_literal: true

RSpec.describe Sumaki::Model::Enum do
  describe '.enum' do
    class SumakiEnumTest
      include Sumaki::Model
      enum :int, { a: 1, b: 2, c: 3 }
      enum :str, { a: 'aaa', b: 'bbb', c: 'ccc' }
      enum :sym, { a: :a_sym, b: :b_sym, c: :c_sym }
    end

    [
      [1, :a],
      [2, :b],
      [3, :c]
    ].each do |actual, expected|
      context "when the value of int is #{actual}" do
        subject(:wrapped) { SumakiEnumTest.new({ int: actual }) }

        it { expect(wrapped.int.name).to eq(expected) }
      end
    end

    [
      ['aaa', :a],
      ['bbb', :b],
      ['ccc', :c]
    ].each do |actual, expected|
      context "when the value of str is #{actual}" do
        subject(:wrapped) { SumakiEnumTest.new({ str: actual }) }

        it { expect(wrapped.str.name).to eq(expected) }
      end
    end

    [
      ['a_sym', :a],
      ['b_sym', :b],
      ['c_sym', :c]
    ].each do |actual, expected|
      context "when the value of sym is #{actual}" do
        subject(:wrapped) { SumakiEnumTest.new({ sym: actual }) }

        it { expect(wrapped.sym.name).to eq(expected) }
      end
    end
  end
end
