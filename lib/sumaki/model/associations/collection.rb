# frozen_string_literal: true

require 'forwardable'

module Sumaki
  module Model
    module Associations
      class Collection # :nodoc:
        include Enumerable
        extend Forwardable

        singleton_class.attr_accessor :reflection

        def_delegators :@models, :each
        def_delegators :@models, :inspect, :pretty_print
        def_delegators 'self.class', :reflection

        def initialize(models = [], owner:)
          @models = models
          @owner = owner
        end

        def build(attrs = {})
          object = @owner.object_accessor.build_repeated_element(reflection.name)
          model = reflection.model_class.new(object, parent: @owner)
          model.assign(attrs)

          self << model

          model
        end

        def <<(...)
          r = @models.<<(...)
          apply
          r
        end

        private

        def apply
          @owner.object_accessor.apply_repeated(reflection.name, @models)
        end
      end
    end
  end
end
