require 'capybara'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/hash/keys'

module QAT::Web
  module Configuration
    # Parses the configuration value into a usable Capybara selector
    #@param config [Hash] value from configuration to save
    #@option config [String] :type Selector type (Capybara.default_selector)
    #@option config [String] :value Selector value
    #@see Capybara::Queries::SelectorQuery
    #@return [Array]
    def parse_configuration config
      Configuration.last_access = config
      @last_access              = config
      type                      = config.fetch :type, Capybara.default_selector
      value                     = config.fetch :value
      opts                      = config.select { |key, _| Capybara::Queries::SelectorQuery::VALID_KEYS.include? key }
      return type.to_sym, value, opts.to_hash.symbolize_keys
    end

    # Returns the last value accessed from configuration
    #@return [Hash]
    def last_access
      @last_access
    end

    class << self
      # Returns the last value accessed from configuration in all QAT::Web::Configuration instances
      #@return [Hash]
      def last_access
        @last_access
      end

      # Sets the last value accessed from configuration in all QAT::Web::Configuration instances
      #@param value [Hash] value from configuration to save
      #@option value [String] :type Selector type (Capybara.default_selector)
      #@option value [String] :value Selector value
      #@see Capybara::Queries::SelectorQuery
      #@return [Hash]
      def last_access=(value)
        @last_access=value
      end
    end
  end
end