# frozen_string_literal: true

module Sumaki
  module Model
    module Fields
      class Reflection # :nodoc:
        def initialize(name)
          @name = name
        end

        def name
          @name.to_sym
        end
      end
    end
  end
end
