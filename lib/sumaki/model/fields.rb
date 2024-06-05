# frozen_string_literal: true

require_relative 'fields/reflection'

module Sumaki
  module Model
    # = Sumaki::Model::Fields
    module Fields
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods
      end

      class FieldAccessor # :nodoc:
        def initialize(model, reflections)
          @model = model
          @reflections = reflections
        end

        def get(field_name)
          reflection = @reflections[field_name]

          value = @model.get(reflection.name)
          reflection.type_class.deserialize(value)
        end

        def set(field_name, value)
          reflection = @reflections[field_name]

          serialized = reflection.type_class.serialize(value)
          @model.set(reflection.name, serialized)
        end
      end

      module AccessorAdder # :nodoc:
        def add(methods_module, reflections, reflection)
          add_getter(methods_module, reflection.name)
          add_setter(methods_module, reflection.name)

          reflections[reflection.name] = reflection
        end

        def add_getter(methods_module, field_name)
          methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
            def #{field_name}                      # def title
              field_accessor.get(:'#{field_name}') #   field_accessor.get(:'title')
            end                                    # end
          RUBY
        end

        def add_setter(methods_module, field_name)
          methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
            def #{field_name}=(value)                     # def title=(value)
              field_accessor.set(:'#{field_name}', value) #   field_accessor.set(:'title', value)
            end                                           # end
          RUBY
        end
        module_function :add, :add_getter, :add_setter
      end

      module ClassMethods # :nodoc:
        # Access to the field.
        #
        #   class Anime
        #     include Sumaki::Model
        #     field :title
        #     field :url
        #   end
        #
        #   anime = Anime.new({ title: 'The Vampire Dies in No Time', url: 'https://sugushinu-anime.jp/' })
        #   anime.title #=> 'The Vampire Dies in No Time'
        #   anime.url #=> 'https://sugushinu-anime.jp/'
        #
        # The Field value cam be set.
        #
        #   anime = Anime.new({})
        #   anime.title = 'The Vampire Dies in No Time'
        #   anime.title #=> 'The Vampire Dies in No Time'
        #
        # == Type casting
        #
        # When a type is specified, it will be typecast.
        #
        #   class Character
        #     include Sumaki::Model
        #
        #     field :age, :int
        #   end
        #
        #   character = Character.new({ age: '208' })
        #   character.age #=> 208
        #
        # Types are:
        #
        # * <tt>:int</tt>
        # * <tt>:float</tt>
        # * <tt>:string</tt>
        # * <tt>:bool</tt>
        # * <tt>:date</tt>
        # * <tt>:datetime</tt>
        def field(name, type = nil)
          reflection = Reflection.new(name, type)
          AccessorAdder.add(_sumaki_methods_module, _sumaki_attribute_reflections, reflection)
        end

        def attribute_names
          _sumaki_attribute_reflections.keys
        end

        def _sumaki_attribute_reflections
          @_sumaki_attribute_reflections ||= {}
        end
      end

      module InstanceMethods # :nodoc:
        def attributes
          self.class.attribute_names.map.with_object({}) { |e, r| r[e] = public_send(e) }
        end

        private

        def field_accessor
          @field_accessor ||= FieldAccessor.new(self, self.class._sumaki_attribute_reflections)
        end
      end
    end
  end
end
