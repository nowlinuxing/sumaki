# frozen_string_literal: true

RSpec.describe Sumaki::Model::Enum do
  describe '.enum' do
    class SumakiEnumTest
      include Sumaki::Model
      enum :type, { a: 1, b: 2, c: 3 }
    end

    describe 'getter' do
      subject(:wrapped) { SumakiEnumTest.new({ type: 2 }) }

      it { expect(wrapped.type.name).to eq(:b) }
    end

    describe 'setter' do
      subject(:type_name) do
        wrapped.type = 2
        wrapped.type.name
      end

      let(:wrapped) { SumakiEnumTest.new({}) }

      it { expect(type_name).to eq(:b) }
    end
  end
end
