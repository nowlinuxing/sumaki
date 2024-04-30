# frozen_string_literal: true

module Sumaki
  module Adapter
    # = Sumaki::Adapter::Hash
    class Hash
      def get(data, key)
        data[key]
      end

      def set(data, key, value)
        data[key] = value
      end
    end
  end
end
