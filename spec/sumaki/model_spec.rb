# frozen_string_literal: true

require 'spec_helper'
require 'pp'

RSpec.describe Sumaki::Model do
  let(:model_class) do
    Class.new do
      const_set(
        :Singular,
        Class.new do
          include Sumaki::Model
          field :sf
        end
      )
      const_set(
        :Repeated,
        Class.new do
          include Sumaki::Model
          field :sr
        end
      )

      include Sumaki::Model

      singular :singular
      repeated :repeated

      field :f1, :int
      enum :enum, { e1: 1, e2: 2, e3: 3 }
      field :f2, :string
    end
  end
  let(:model) do
    data = {
      f1: 123,
      enum: 2,
      f2: 'abc',
      singular: { sf: 456 },
      repeated: [{ sr: 'r1' }, { sr: 'r2' }]
    }
    model_class.new(data)
  end

  describe '#inspect' do
    subject { model.inspect }

    it { is_expected.to eq('#< f1: 123, enum: :e2, f2: "abc">') }
  end

  describe '#pretty_print' do
    subject do
      out = +''
      PP.pp(model, out)
      out
    end

    it { is_expected.to match(/\A#<#{model_class}:0x\h+ f1: 123, enum: :e2, f2: "abc">\n\z/) }
  end
end
