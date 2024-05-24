# frozen_string_literal: true

require_relative 'type'

module Sumaki
  module Model
    module Fields
      class Reflection # :nodoc:
        def initialize(name, type = nil)
          @name = name
          @type = type
        end

        def name
          @name.to_sym
        end

        def type_class
          @type_class ||= @type.nil? ? Type::Value : Type.lookup(@type)
        end
      end
    end
  end
end
