# frozen_string_literal: true

module Sumaki
  module Model
    module Fields
      module Type
        class Error < StandardError; end
        class ArgumentError < Error; end
        class TypeError < Error; end

        class Value # :nodoc:
          def self.serialize(value)
            value
          end

          def self.deserialize(value)
            value
          end

          def self.try_casting
            yield
          rescue ::ArgumentError
            raise Type::ArgumentError
          rescue ::TypeError
            raise Type::TypeError
          end
          private_class_method :try_casting
        end
      end
    end
  end
end
