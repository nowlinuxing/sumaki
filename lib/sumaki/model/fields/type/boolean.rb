# frozen_string_literal: true

require_relative 'value'

module Sumaki
  module Model
    module Fields
      module Type
        class Boolean < Value # :nodoc:
          def self.serialize(value)
            return if value.nil?

            case value
            when true  then true
            when false then false
            else
              raise ArgumentError
            end
          end

          def self.deserialize(value)
            case value
            when true  then true
            when false then false
            end
          end
        end
      end
    end
  end
end
