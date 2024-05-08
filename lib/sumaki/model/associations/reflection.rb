# frozen_string_literal: true

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
              klass = if @owner_class.const_defined?(basename)
                        @owner_class.const_get(basename)
                      else
                        @owner_class.const_set(basename, Class.new { include Model })
                      end
              klass.parent = @owner_class
              klass
            end
          end

          private

          def classify(str)
            str.gsub(/([a-z\d]+)_?/) { |_| Regexp.last_match(1).capitalize }
          end
        end

        class Singular < Base # :nodoc:
        end

        class Repeated < Base # :nodoc:
        end
      end
    end
  end
end
