# frozen_string_literal: true

module Sumaki
  module Adapter
    # = Sumaki::Adapter::Hash
    class Hash
      def get(data, key)
        data[key]
      end
    end
  end
end
