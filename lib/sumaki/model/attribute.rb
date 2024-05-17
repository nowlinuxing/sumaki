# frozen_string_literal: true

module Sumaki
  module Model
    # = Sumaki::Model::Attribute
    module Attribute
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods
      end

      module AccessorAdder # :nodoc:
        def add(methods_module, field_name)
          add_getter(methods_module, field_name)
          add_setter(methods_module, field_name)
        end

        def add_getter(methods_module, field_name)
          methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
            def #{field_name}       # def title
              get(:'#{field_name}') #   get(:'title')
            end                     # end
          RUBY
        end

        def add_setter(methods_module, field_name)
          methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
            def #{field_name}=(value)      # def title=(value)
              set(:'#{field_name}', value) #   set(:'title', value)
            end                            # end
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
        def field(name)
          field_names << name.to_sym
          AccessorAdder.add(attribute_methods_module, name)
        end

        def field_names
          @field_names ||= []
        end

        private

        def attribute_methods_module
          @attribute_methods_module ||= begin
            mod = Module.new
            include mod
            mod
          end
        end
      end

      module InstanceMethods # :nodoc:
        def fields
          self.class.field_names.map.with_object({}) { |e, r| r[e] = public_send(e) }
        end
      end
    end
  end
end
