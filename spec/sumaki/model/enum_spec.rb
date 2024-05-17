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
  end
end
