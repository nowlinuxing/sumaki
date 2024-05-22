# frozen_string_literal: true

require_relative 'value'

module Sumaki
  module Model
    module Fields
      module Type
        class Integer < Value # :nodoc:
          def self.serialize(value)
            try_casting do
              value.nil? ? nil : Integer(value)
            end
          end

          def self.deserialize(value)
            value.nil? ? nil : Integer(value, exception: false)
          end
        end
      end
    end
  end
end
