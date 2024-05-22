# frozen_string_literal: true

require_relative 'value'

module Sumaki
  module Model
    module Fields
      module Type
        class Float < Value # :nodoc:
          def self.serialize(value)
            try_casting do
              value.nil? ? nil : Float(value)
            end
          end

          def self.deserialize(value)
            value.nil? ? nil : Float(value, exception: false)
          end
        end
      end
    end
  end
end
