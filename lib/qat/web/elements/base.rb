require 'capybara/dsl'
require_relative 'selector'
require_relative 'config'

module QAT
  module Web
    module Elements
      # Web Element wrapper base class
      class Base
        include Capybara::DSL
        include QAT::Logger
        include Selector
        include Config

        attr_reader :name, :config, :selector

        # New instance
        # @param elements [Hash] Page Object related elements configuration
        # @param args [Array] One or two arguments are expected. The first argument is the element *name*
        # and the second an optional *configuration*.
        # If none is given, it will be automatically loaded from the loaded configuration by the element name
        def initialize(elements, *args)
          get_element_info(elements, *args)
          @selector = extract_selector(@config)
        end

        private
        # Parsed the configuration information for element or collection of elements
        # @param args [Array] One or two arguments are expected. The first argument is the element *name*
        # and the second an optional *configuration*.
        # If none is given, it will be automatically loaded from the loaded configuration by the element name
        # @raise ArgumentError if more than two arguments are given.
        # @raise ArgumentError if a nil configuration is given.
        # @raise ArgumentError if no configuration is found in cache.
        # @return [Array]
        def get_element_info(elements, *args)
          raise ArgumentError.new "Wrong number of arguments! Expecting [name, configuration]!" if args.size > 2

          @name, @config = args
          raise ArgumentError.new "Configuration given for element '#{@name}' is nil!" if args.size == 2 && @config.nil?

          @config ||= elements[:locators][@name]
          raise ArgumentError.new "No configuration found for web element '#{@name}', please check definition" if @config.nil? or (@config.is_a? Hash and @config.empty?)

          [@name, @config]
        end
      end
    end
  end
end