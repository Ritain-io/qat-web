require_relative 'elements/selector'
require_relative 'elements/waiters'
require_relative 'elements/base'
require_relative 'elements/element'
require_relative 'elements/collection'

module QAT
  module Web
    # Helper methods to define elements and load configurations.
    # Auxiliary methods for the elements are also defined here.
    module Elements
      include Selector
      include Waiters

      # Loads a configuration file
      # @param file_path [String] configuration file path
      # @return [Hash]
      def load_elements_file(file_path)
        begin
          config = YAML::load(ERB.new(File.read(file_path)).result)
        rescue Psych::SyntaxError
          log.error "Failed to load file '#{file_path}'."
          raise
        end
        config
      end

      private
      # Defines all dynamic web elements methods
      # @param web_element [Element|Collection] web element configuration
      def define_web_element_methods(web_element)
        define_method(web_element.name) { web_element.finder.call }
        define_selectors(web_element)
        define_config_accessor(web_element)
        define_waiters(web_element)
      end

      # Defines the configuration accessor for the web elements
      # @param web_element [Element] web element object
      def define_config_accessor(web_element)
        define_method "config_#{web_element.name}" do
          web_element.config
        end
      end

      # Defines the selector accessor for the web elements
      # @param web_element [Element] web element object
      def define_selectors(web_element)
        define_method "selector_#{web_element.name}" do
          web_element.selector
        end
      end

      # Defines the waiting methods for the web elements
      # @param web_element [Element] web element object
      def define_waiters(web_element)
        selector = web_element.selector
        name     = web_element.name

        define_method "wait_until_#{name}_visible" do |timeout|
          wait_until_visible(selector, timeout)
        end

        define_method "wait_until_#{name}_present" do |timeout|
          wait_until_present(selector, timeout)
        end

        define_method "wait_while_#{name}_visible" do |timeout|
          wait_until_not_visible(selector, timeout)
        end

        define_method "wait_while_#{name}_present" do |timeout|
          wait_until_not_present(selector, timeout)
        end
      end
    end
  end
end