# frozen_string_literal: true

module Sumaki
  module Model
    # = Sumaki::Model::Attribute
    module Attribute
      def self.included(base)
        base.extend ClassMethods
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
        def field(name)
          attribute_methods_module.module_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{name}       # def title
              get(:'#{name}') #   get(:'title')
            end               # end
          RUBY
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
    end
  end
end
