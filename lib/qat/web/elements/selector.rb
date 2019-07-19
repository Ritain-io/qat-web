require 'qat/web/configuration'
require 'active_support/core_ext/hash/keys'

module QAT
  module Web
    module Elements
      # Helper methods for handling selectors and selector transformations
      module Selector
        include QAT::Web::Configuration

        # Invalid Configuration Errors
        class InvalidConfigurationError < StandardError
          # Creates a new InvalidConfigurationError
          # @param config [Hash] element selector configuration
          def initialize(config)
            super "Invalid configuration found:\n#{config.ai}"
          end
        end

        # Returns the selector from configuration
        # @param config [Hash] element selector configuration
        # @param args [Array] (Optional) Substitutions to the XPATH string base in $ syntax
        # @return [Array] selector
        #
        # @example
        #   xpath with ".//div[@class='ng-pristine' and text()='$0']//span[contains(text(), '$1')]"
        #   args with: ["Some Text", "More Text" ]
        #   The final output will be ".//div[@class='ng-pristine' and text()='Some Text']//span[contains(text(), 'More Text')]"
        #
        def selector(config, *args)
          extract_selector(config, *args)
        end

        private

        # Extracts the ID or XPATH from the immediate node from the config
        #
        # @param config [Hash] element selector configuration
        # @param args [Array] (Optional) Substitutions to the XPATH string base in $ syntax
        # @return [Array] selector
        #
        # @example
        #   xpath with ".//div[@class='ng-pristine' and text()='$0']//span[contains(text(), '$1')]"
        #   args with: ["Some Text", "More Text" ]
        #   The final output will be ".//div[@class='ng-pristine' and text()='Some Text']//span[contains(text(), 'More Text')]"
        #
        def extract_selector(config, *args)
          type  = fetch_type(config)
          value = parse_value(config[type], *args)
          opts  = options(config)
          save_config(type, value, opts)
          if opts.any?
            return type.to_sym, value, opts
          else
            return type.to_sym, value
          end
        end

        # Returns the correct selector type from configuration
        # @param config [Hash] element selector configuration
        # @return [Symbol]
        def fetch_type(config)
          types = Capybara::Selector.all.keys & config.symbolize_keys.keys

          raise InvalidConfigurationError.new config unless types.size == 1

          types.first
        end

        # Parse the selector value for the given configuration through given arguments
        # A list of substitutions will be applied from those arguments
        # @param value [String] selector value
        # @param args [Array] list of substitutions to apply
        # @see #extract_selector
        def parse_value(value, *args)
          if args.empty?
            value
          else
            args.each_with_index do |arg, index|
              value = value.gsub("$#{index}", arg)
            end
            value
          end
        end

        # Return valid options for Capybara
        # @param config [Hash] element selector configuration
        # @return [Array]
        def options(config)
          config.symbolize_keys.select { |key, _| Capybara::Queries::SelectorQuery::VALID_KEYS.include?(key) }
        end

        # Saves the last configuration access
        # @param type [Symbol] selector type
        # @param value [String] selector value
        # @param opts [Hash] selector options
        # @return [Hash]
        def save_config(type, value, opts)
          config                              = { type => value }.merge(opts)
          QAT::Web::Configuration.last_access = config
          @last_access                        = config
        end

        extend self
      end
    end
  end
end
