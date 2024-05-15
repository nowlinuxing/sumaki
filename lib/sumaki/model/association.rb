# frozen_string_literal: true

module Sumaki
  module Model
    # = Sumaki::Model::Association
    module Association
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods

        base.instance_variable_set(:@classes, {})
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
          klass = class_for(name, class_name)

          association_methods_module.define_method(name) do
            klass.new(get(name), parent: self)
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
          klass = class_for(name, class_name)

          association_methods_module.define_method(name) do
            get(name).map { |object| klass.new(object, parent: self) }
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

        def class_for(name, class_name = nil)
          return @classes[name] if @classes.key?(name)

          basename = class_name || classify(name.to_s)
          klass = if const_defined?(basename)
                    const_get(basename)
                  else
                    const_set(basename, Class.new { include Model })
                  end
          klass.parent ||= self
          @classes[name] = klass
        end

        def classify(key)
          key.gsub(/([a-z\d]+)_?/) { |_| Regexp.last_match(1).capitalize }
        end
      end
    end
  end
end
