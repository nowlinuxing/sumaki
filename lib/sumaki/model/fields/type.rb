# frozen_string_literal: true

require_relative 'type/value'
require_relative 'type/integer'
require_relative 'type/float'
require_relative 'type/string'
require_relative 'type/boolean'
require_relative 'type/date'
require_relative 'type/date_time'

module Sumaki
  module Model
    module Fields
      module Type # :nodoc:
        class Types # :nodoc:
          def initialize
            @types = {}
          end

          def register(name, type_class)
            @types[name] = type_class
          end

          def lookup(type_name)
            @types.fetch(type_name)
          end
        end

        @types = Types.new

        def register(...)
          @types.register(...)
        end

        def lookup(...)
          @types.lookup(...)
        end

        module_function :register, :lookup

        register(:int, Integer)
        register(:float, Float)
        register(:string, String)
        register(:bool, Boolean)
        register(:date, Date)
        register(:datetime, DateTime)
      end
    end
  end
end
