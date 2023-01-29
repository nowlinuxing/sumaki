# frozen_string_literal: true

module Sumaki
  module Model
    # = Sumaki::Model::Enum
    module Enum
      def self.included(base)
        base.extend ClassMethods
      end

      class EnumValue < Hash # :nodoc:
        code = <<-RUBY
          case value
          when Symbol then super(value) || super(value.to_s)
          when String then super(value) || super(value.to_sym)
          else super(value)
          end
        RUBY

        class_eval <<-RUBY, __FILE__, __LINE__ + 1 # rubocop:disable Style/DocumentDynamicEvalDefinition
          def key?(value); #{code}; end
        RUBY

        class_eval <<-RUBY, __FILE__, __LINE__ + 1 # rubocop:disable Style/DocumentDynamicEvalDefinition
          def key(value); #{code}; end
        RUBY

        class_eval <<-RUBY, __FILE__, __LINE__ + 1 # rubocop:disable Style/DocumentDynamicEvalDefinition
          def value?(value); #{code}; end
        RUBY
      end

      module ClassMethods # :nodoc:
        # Map a field to the specified value
        #
        #   class Character
        #     include Sumaki::Model
        #     field :name
        #     enum :type, vampire: 1, vampire_hunter: 2, familier: 3, editor: 4
        #   end
        #
        #   data = {
        #     name: 'John',
        #     type: 3
        #   }
        #
        #   character = Character.new(data)
        #   character.type #=> :familier
        def enum(name, **values)
          values = EnumValue[values]

          enum_methods_module.define_method(name) do
            value = get(name)

            if values.key?(value)
              value
            elsif values.value?(value)
              values.key(value)
            end
          end
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
