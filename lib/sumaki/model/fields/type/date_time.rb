# frozen_string_literal: true

require_relative 'value'
require 'date'

module Sumaki
  module Model
    module Fields
      module Type
        class DateError < Error; end

        class DateTime < Value # :nodoc:
          def self.serialize(value)
            value.nil? ? nil : cast(value)
          rescue ::Date::Error
            raise DateError
          end

          def self.deserialize(value)
            value.nil? ? nil : cast(value)
          rescue ::Date::Error
            nil
          end

          def self.cast(value)
            return value.to_datetime if value.respond_to?(:to_datetime)

            ::DateTime.parse(value.to_s)
          end
          private_class_method :cast
        end
      end
    end
  end
end
