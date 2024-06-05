# frozen_string_literal: true

require_relative 'model/fields'
require_relative 'model/associations'
require_relative 'model/enum'

module Sumaki
  # = Sumaki
  #
  # Sumaki is a wrapper for structured data like JSON.
  #
  #   class AnimeList
  #     include Sumaki::Model
  #     repeated :anime
  #     field :name
  #
  #    class Anime
  #       include Sumaki::Model
  #       singular :studio
  #       field :title
  #
  #       class Studio
  #         include Sumaki::Model
  #         field :name
  #       end
  #     end
  #   end
  #
  #   data = {
  #     name: 'Winter 2023',
  #     anime: [
  #       {
  #         title: 'The Vampire Dies in No Time',
  #         studio: {
  #           name: 'MADHOUSE Inc.'
  #         }
  #       },
  #       {
  #         title: '“Ippon” again!',
  #         studio: {
  #           name: 'BAKKEN RECORD'
  #         }
  #       }
  #     ]
  #   }
  #
  #   anime_list = AnimeList.new(data)
  #   anime_list.name #=> 'Winter 2023'
  #   anime_list.anime[0].title #=> 'The Vampire Dies in No Time'
  #   anime_list.anime[0].studio.name #=>  'MADHOUSE Inc.'
  #   anime_list.anime[0].object #=> { title: 'The Vampire Dies in No Time', studio: { name: 'MADHOUSE Inc.' } }
  #
  # == Access to fields
  #
  # By declaring `field`, you can access the field.
  #
  #   class Anime
  #     include Sumaki::Model
  #     field :title
  #     field :url
  #   end
  #
  #   anime = Anime.new({ title: "The Vampire Dies in No Time", url: "https://sugushinu-anime.jp/" })
  #   anime.title #=> "The Vampire Dies in No Time"
  #
  # == Access to sub objects
  #
  # By declaring `singular`, you can access the sub object.
  #
  #   class Book
  #     include Sumaki::Model
  #     singular :company
  #     field :title
  #
  #     class Company
  #       include Sumaki::Model
  #       field :name
  #     end
  #   end
  #
  #   data = {
  #     title: "The Ronaldo Chronicles",
  #     company: {
  #       name: 'Autumn Books',
  #     }
  #   }
  #
  #   comic = Book.new(data)
  #   comic.company.name #=> 'Autumn Books'
  #
  # By declaring `repeated`, you can access the repeated sub objects as an Array.
  #
  #   class Company
  #     include Sumaki::Model
  #     repeated :member
  #     field :name
  #
  #     class Member
  #       include Sumaki::Model
  #       field :name
  #     end
  #   end
  #
  #   data = {
  #     name: 'The Ronaldo Vampire Hunter Agency',
  #     member: [
  #       { name: 'Ronaldo' },
  #       { name: 'Draluc' },
  #       { name: 'John' }
  #     ]
  #   }
  #
  #   company = Company.new(data)
  #   company.member.size #=> 3
  #   company.member[2].name #=> 'John'
  #
  # == Access to the parent object
  #
  # Parent object can be referenced from sub object by `#parent` method.
  #
  #   class Character
  #     include Sumaki::Model
  #     singular :child
  #     field :name
  #
  #     class Child
  #       include Sumaki::Model
  #       field :name
  #     end
  #   end
  #
  #   data = {
  #     name: 'Draus',
  #     child: {
  #       name: 'Draluc'
  #     }
  #   }
  #
  #   character = Character.new(data)
  #   character.child.name #=> 'Draluc'
  #   character.child.parent.name #=> 'Draus'
  #
  # == Enumerations
  #
  # By declaring `enum`, You can map a field to a specified value.
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
  #
  module Model
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods

      base.include Fields
      base.include Associations
      base.include Enum
    end

    module ClassMethods # :nodoc:
      attr_writer :adapter
      attr_accessor :parent

      def adapter
        @adapter || parent&.adapter || Config.default_adapter
      end

      def _sumaki_methods_module
        @_sumaki_methods_module ||= begin
          mod = Module.new
          include mod
          mod
        end
      end
    end

    class ObjectAccessor # :nodoc:
      def initialize(object, adapter)
        @object = object
        @adapter = adapter
      end

      def get(name)
        @adapter.get(@object, name)
      end

      def set(name, value)
        @adapter.set(@object, name, value)
      end

      def build_singular(name)
        @adapter.build_singular(@object, name)
      end

      def build_repeated_element(name)
        @adapter.build_repeated_element(@object, name)
      end

      def apply_repeated(name, models)
        @adapter.apply_repeated(@object, name, models.map(&:object))
      end
    end

    module InstanceMethods # :nodoc:
      attr_reader :object, :parent

      def initialize(object, parent: nil)
        @object = object
        @parent = parent
      end

      def object_accessor
        @object_accessor ||= ObjectAccessor.new(object, self.class.adapter)
      end

      def get(name)
        object_accessor.get(name)
      end

      def set(name, value)
        object_accessor.set(name, value)
      end

      def assign(attrs)
        attrs.each do |attr, value|
          public_send(:"#{attr}=", value)
        end
      end

      def inspect
        inspection = fields
                     .map { |name, value| "#{name}: #{value.inspect}" }
                     .join(', ')
        "#<#{self.class.name} #{inspection}>"
      end

      def pretty_print(pp) # rubocop:disable Metrics/MethodLength
        pp.object_address_group(self) do
          pp.seplist(fields, -> { pp.text ',' }) do |field, value|
            pp.breakable
            pp.group(1) do
              pp.text field.to_s
              pp.text ':'
              pp.breakable
              pp.pp value
            end
          end
        end
      end
    end
  end
end
