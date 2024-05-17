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

      def build_singular(data, name)
        data[name] = {}
      end

      def build_repeated_element(_data, _name)
        {}
      end

      def apply_repeated(data, name, objects)
        data[name] = objects
      end
    end
  end
end
