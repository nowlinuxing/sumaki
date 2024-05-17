# frozen_string_literal: true

require 'minenum'

module Sumaki
  module Model
    # = Sumaki::Model::Enum
    module Enum
      def self.included(base)
        base.include Minenum::Model
        base.extend ClassMethods
      end

      module EnumAttrAccessor # :nodoc:
        def get(model, name)
          model.get(name)
        end

        def set(model, name, value)
          model.set(name, value)
        end
        module_function :get, :set
      end

      module ClassMethods # :nodoc:
        # Map a field to the specified value
        #
        #   class Character
        #     include Sumaki::Model
        #     field :name
        #     enum :type, { vampire: 1, vampire_hunter: 2, familier: 3, editor: 4 }
        #   end
        #
        #   data = {
        #     name: 'John',
        #     type: 3
        #   }
        #
        #   character = Character.new(data)
        #   character.type.name #=> :familier
        #   character.type.familier? #=> true
        #   character.type.vampire? #=> false
        #
        # Enum can also be set.
        #
        #   character = Character.new({})
        #   character.type = 1
        #   character.type.name #=> :vampire
        def enum(name, values)
          super(name, values, adapter: EnumAttrAccessor)
        end

        private

        def enum_methods_module
          @enum_methods_module ||= begin
            mod = Module.new
            include mod
            mod
          end
        end
      end
    end
  end
end
