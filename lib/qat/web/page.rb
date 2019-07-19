require_relative 'version'
require_relative 'elements'
require_relative 'page/validators'

module QAT::Web

  #Class to represent a Web Page. Works based on a DSL to write user friendly and powerful transition models.
  #Two class methods are provided by this class, in order to allow the mapping of getters for page values, and also map
  #page transitions.
  #The use of Capybara::DSL in the implementation is recommended.
  # @example Sample Page Object implementation for http://localhost:8090/example
  #   class ExamplePage < QAT::Web::Page
  #     include Capybara::DSL
  #
  #    def initialize
  #      visit 'http://localhost:8090/example'
  #    end
  #
  #     get_value :title do
  #       find 'h1'
  #     end
  #
  #     action :more_information, returns: ExampleInformationPage do
  #       click_link 'More information...'
  #       ExampleInformationPage.new
  #     end
  #   end
  #
  #   current_page = ExamplePage.new
  #   current_page.title # 'Example Domain'
  #   current_page = current_page.more_information # ExampleInformationPage instance
  #
  #@see http://www.rubydoc.info/github/jnicklas/capybara/master/Capybara/DSL Capybara::DSL
  #@abstract
  #@since 1.0.0
  class Page
    include Elements
    extend Elements
    extend Elements::Waiters

    class << self
      include Validators

      #@return [Array<Symbol>] List of value getter functions
      def values
        @values ||= []
        if superclass.ancestors.include? QAT::Web::Page
          @values + superclass.values
        else
          @values
        end
      end


      #@return [Hash<Symbol, Array<QAT::Web::Page>>] List of page actions and respective transition return types
      def actions
        @actions ||= {}
        if superclass.ancestors.include? QAT::Web::Page
          superclass.actions.merge @actions
        else
          @actions
        end
      end

      #Define a new method to get a value from a page. A new instance method will be defined with the given name
      #parameter, and with the block as the method's code to be executed. The name of the method will be added to {QAT::Web::Page#values}
      #@param name [String/Symbol] Name of the funcion to be defined
      #@yield Block of code to define the getter method. The block will only be executed then the function defined by "name" is called
      def get_value name, &block
        name = name.to_sym
        define_method name, &block
        @values ||= []
        @values << name
      end

      #Define a new method to represent a possible page transition to another page object controller. A new instance method
      #will be defined with the given name parameter, and with the block as the method's code to be executed.
      #Additionally, all possible return types must be delacred in the :returns key in the opts parameter.
      #All return types must be implementarions of QAT::Web::Page.
      #@param name [String/Symbol] Name of the funcion to be defined
      #@param opts [Hash] Options hash
      #@option opts [Class/Array<Class>] :returns Sublass or list of subclasses of QAT::Web::Page that can be returned by the method definition
      #@yield Block of code to define the getter method. The block will only be executed then the function defined by "name" is called
      #@yieldreturn [QAT::Web::Page] Instance of the destination page object
      def action name, opts, &block

        raise TypeError.new 'The opts parameter should be an Hash with a :returns key' unless opts.is_a? Hash

        return_value = validate_return_value(opts[:returns])

        name = name.to_sym
        define_method name, &block
        @actions       ||= {}
        @actions[name] = return_value
      end

      # Loads elements configuration from a configuration file given a file path
      # @param path [String] path to configuration file
      # @return [HashWithIndifferentAccess]
      def elements_file(path)
        raise(ArgumentError, "File '#{path}' does not exist!") unless File.exist?(path)
        @elements_file = path
        elements_config(load_elements_file(@elements_file))
      end

      # Defines elements through a configuration hash
      # @param elements [Hash] elements configuration
      # @return [HashWithIndifferentAccess]
      def elements_config(elements)
        valid_config?(elements, 'elements')
        @elements = HashWithIndifferentAccess.new(elements)
      end

      # Returns the elements configuration
      # @return [HashWithIndifferentAccess]
      def elements
        @elements
      end

      # Defines a web element accessor identified through the given name and configuration
      # Auxiliary methods are also dynamically defined such as the element acessor, waiters and the configuration accessor
      # @param args [Array] One or two arguments are expected. The first argument is the element *name*
      # and the second an optional *configuration*.
      # If none is given, it will be automatically loaded from the loaded configuration by the element name
      # @see Capybara::Node::Finders#find
      def web_element(*args)
        element = QAT::Web::Elements::Element.new(elements, *args)
        define_web_element_methods(element)
      end

      # Defines a list of web element accessors identified through the given names
      # Configuration will be automatically loaded from the loaded configuration by element name
      # Auxiliary methods are also dynamically defined such as the element acessor, waiters and the configuration accessor
      # @param elements [Array|Symbol] list of names to load elements
      # @see Capybara::Node::Finders#find
      def web_elements(*elements)
        elements.each { |element| web_element(element) }
      end

      # Defines a collection of web elements identified through a given name and configuration
      # Auxiliary methods are also dynamically defined such as the element acessor, waiters and the configuration accessor
      # @param args [Array] One or two arguments are expected. The first argument is the element *name*
      # and the second an optional *configuration*.
      # If none is given, it will be automatically loaded from the loaded configuration by the element name
      # @see Capybara::Node::Finders#all
      def web_collection(*args)
        collection = QAT::Web::Elements::Collection.new(elements, *args)
        define_web_element_methods(collection)
      end
    end

    # Returns the elements configuration
    # @return [HashWithIndifferentAccess]
    def elements
      self.class.elements
    end
  end
end