# frozen_string_literal: true

module Sumaki
  module Model
    module Associations
      module Association
        class Singular # :nodoc:
          def initialize(owner, reflection)
            @owner = owner
            @reflection = reflection
          end

          def model
            @model ||= begin
              object = @owner.get(@reflection.name)
              object.nil? ? nil : @reflection.model_class.new(object, parent: @owner)
            end
          end

          def build_model(attrs = {})
            assoc = @owner.object_accessor.build_singular(@reflection.name)

            model = @reflection.model_class.new(assoc, parent: @owner)
            model.assign(attrs)

            @model = model
          end
        end

        class Repeated # :nodoc:
          def initialize(owner, reflection)
            @owner = owner
            @reflection = reflection
          end

          def collection
            @collection ||= begin
              objects_or_value = @owner.get(@reflection.name)
              models = if objects_or_value.is_a?(Array)
                         model_class = @reflection.model_class
                         objects_or_value.map { |object| model_class.new(object, parent: @owner) }
                       else
                         []
                       end

              @reflection.collection_class.new(models, owner: @owner)
            end
          end
        end
      end
    end
  end
end
