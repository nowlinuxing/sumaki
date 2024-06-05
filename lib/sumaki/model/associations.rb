# frozen_string_literal: true

require_relative 'associations/reflection'
require_relative 'associations/association'

module Sumaki
  module Model
    # = Sumaki::Model::Associations
    module Associations
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods
      end

      module AccessorAdder
        module Singular # :nodoc:
          def add(methods_module, reflections, reflection)
            add_getter(methods_module, reflection.name)
            add_builder(methods_module, reflection.name)

            reflections[reflection.name] = reflection
          end

          private

          def add_getter(methods_module, name)
            methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
              def #{name}                   # def author
                association(:#{name}).model #   association(:author).model
              end                           # end
            RUBY
          end

          def add_builder(methods_module, name)
            methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
              def build_#{name}(attrs = {})              # def build_author(attrs = {})
                association(:#{name}).build_model(attrs) #   association(:author).build_model(attrs)
              end                                        # end
            RUBY
          end

          module_function :add, :add_getter, :add_builder
        end

        module Repeated # :nodoc:
          def add(methods_module, reflections, reflection)
            methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
              def #{reflection.name}                        # def book
                association(:#{reflection.name}).collection #   association(:book).collection
              end                                           # end
            RUBY

            reflections[reflection.name] = reflection
          end
          module_function :add
        end
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
        # Sub object can also be created.
        #
        #   book = Book.new({})
        #   book.build_company(name: 'Autumn Books')
        #   book.company #=> #<Book::Company:0x000073a618e31e80 name: "Autumn Books">
        #
        # == Options
        #
        # [:class_name]
        #   Specify the name of the class to wrap. Use this if the name of the class
        #   to wrap is not inferred from the nested field names.
        def singular(name, class_name: nil)
          reflection = Reflection::Singular.new(self, name, class_name: class_name)
          AccessorAdder::Singular.add(association_methods_module, reflections, reflection)
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
        # Sub object can also be created.
        #
        #   company = Company.new({})
        #   company.member.build(name: 'John')
        #   company.member[0].name #=> 'John'
        #
        # == Options
        #
        # [:class_name]
        #   Specify the name of the class to wrap. Use this if the name of the class
        #   to wrap is not inferred from the nested field names.
        def repeated(name, class_name: nil)
          reflection = Reflection::Repeated.new(self, name, class_name: class_name)
          AccessorAdder::Repeated.add(association_methods_module, reflections, reflection)
        end

        def reflections
          @reflections ||= {}
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

      module InstanceMethods # :nodoc:
        private

        def association(name)
          @associations ||= {}
          @associations[name.to_sym] ||= self.class.reflections[name.to_sym].association_for(self)
        end
      end
    end
  end
end
