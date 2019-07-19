require_relative 'version'
require_relative 'configuration'
require 'capybara'

module QAT::Web
  #Module with custom finders based on configuration
  #since 1.0.0
  module Finders
    include Configuration
    #Alias to Capybara::Node::Finders#find method with parameter loading from configuration.
    #An +Hash+ should be provided to calculate the correct parameters to pass to the original +find+ method.
    #@param config [Hash] Configuration to extract parameters from
    #@option config [String] :type Selector type (Capybara.default_selector)
    #@option config [String] :value Selector value
    #@see Capybara::Node::Finders#find
    #@see Capybara::Queries::SelectorQuery
    #@return [Capybara::Session] Current session
    #@since 1.0.0
    def find_from_configuration config
      type, value, opts = parse_configuration config
      page.find type, value, opts
    end

    #Alias to Capybara::Node::Finders#within method with parameter loading from configuration.
    #An +Hash+ should be provided to calculate the correct parameters to pass to the original +within+ method.
    #@param config [Hash] Configuration to extract parameters from
    #@option config [String] :type Selector type (Capybara.default_selector)
    #@option config [String] :value Selector value
    #@see Capybara::Node::Finders#find
    #@see Capybara::Queries::SelectorQuery
    #@return [Capybara::Session] Current session
    #@since 1.0.0
    def within_from_configuration config, &block
      type, value, opts = parse_configuration config
      page.within type.to_sym, value, opts, &block
    end

    #Alias to Capybara::DSL base method
    #@return [Capybara::Session] Current session
    #@since 1.0.0
    def page
      Capybara.current_session
    end
  end
end

Capybara::Node::Base.include QAT::Web::Finders
Capybara::Node::Simple.include QAT::Web::Finders

