# frozen_string_literal: true

require_relative 'collection'

module Sumaki
  module Model
    module Associations
      module Reflection
        class Base # :nodoc:
          def initialize(owner_class, name, class_name: nil)
            @owner_class = owner_class
            @name = name
            @class_name = class_name
          end

          def name = @name.to_sym

          def model_class
            @model_class ||= begin
              basename = @class_name&.to_s || classify(@name.to_s)
              klass = if @owner_class.const_defined?(basename, false)
                        @owner_class.const_get(basename, false)
                      else
                        @owner_class.const_set(basename, Class.new { include Model })
                      end
              klass.parent = @owner_class
              klass
            end
          end

          def association_for(model)
            self.class.association_class.new(model, self)
          end

          private

          def classify(str)
            str.gsub(/([a-z\d]+)_?/) { |_| Regexp.last_match(1).capitalize }
          end
        end

        class Singular < Base # :nodoc:
          def self.association_class = Association::Singular
        end

        class Repeated < Base # :nodoc:
          def self.association_class = Association::Repeated

          def collection_class
            @collection_class ||= begin
              class_name = "#{model_class.name[/(\w+)$/]}Collection"

              if @owner_class.const_defined?(class_name)
                @owner_class.const_get(class_name)
              else
                @owner_class.const_set(class_name, Collection.build_subclass(self))
              end
            end
          end
        end
      end
    end
  end
end
