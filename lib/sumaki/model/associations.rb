# frozen_string_literal: true

require_relative 'associations/reflection'

module Sumaki
  module Model
    # = Sumaki::Model::Associations
    module Associations
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods
      end

      module ClassMethods # :nodoc:
        # Access to the sub object.
        #
        #   class Book
        #     include Sumaki::Model
        #     singular :company
        #
        #     class Company
        #       include Sumaki::Model
        #     end
        #   end
        #
        #   data = {
        #     title: 'The Ronaldo Chronicles',
        #     company: {
        #       name: 'Autumn Books',
        #     }
        #   }
        #   book = Book.new(data)
        #   book.company.class #=> Book::Company
        #
        # == Options
        #
        # [:class_name]
        #   Specify the name of the class to wrap. Use this if the name of the class
        #   to wrap is not inferred from the nested field names.
        def singular(name, class_name: nil)
          reflection = Reflection::Singular.new(self, name, class_name: class_name)

          association_methods_module.define_method(reflection.name) do
            reflection.model_class.new(get(reflection.name), parent: self)
          end
        end

        # Access to the repeated sub objects
        #
        #   class Company
        #     include Sumaki::Model
        #     repeated :member
        #
        #     class Member
        #       include Sumaki::Model
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
        #   company = Company.new(data)
        #   company.member[2].class #=> Company::Member
        #
        # == Options
        #
        # [:class_name]
        #   Specify the name of the class to wrap. Use this if the name of the class
        #   to wrap is not inferred from the nested field names.
        def repeated(name, class_name: nil)
          reflection = Reflection::Repeated.new(self, name, class_name: class_name)

          association_methods_module.define_method(reflection.name) do
            get(reflection.name).map { |object| reflection.model_class.new(object, parent: self) }
          end
        end

        private

        def association_methods_module
          @association_methods_module ||= begin
            mod = Module.new
            include mod
            mod
          end
        end
      end
    end
  end
end
