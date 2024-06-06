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

      class EnumAttrAccessor < Minenum::Enum::Adapter::Base # :nodoc:
        def get
          @enum_object.get(@name)
        end

        def set(value)
          @enum_object.set(@name, value)
        end
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
          _minenum_enum(name, values, _sumaki_methods_module, _sumaki_attribute_reflections,
                        adapter_builder: EnumAttrAccessor)
        end
      end
    end
  end
end
