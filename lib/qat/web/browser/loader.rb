require 'capybara'
require_relative '../version'
require_relative '../drivers/default'
require_relative 'profile'
require_relative 'firefox/loader/helper'
require 'retriable'
require 'erb'
require 'active_support'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/hash/indifferent_access'

module QAT::Web
  module Browser
    # Module to load browsers and drivers from configuration files.
    #@since 1.0.0
    module Loader
      include Drivers::Default
      include QAT::Web::Browser::Profile
      include Helper
      extend self

      # Registers browser drivers in Capybara from a YAML file
      #@param file_path [String] file containing browser drivers
      #@since 1.0.0
      def load(file_path)
        controllers = HashWithIndifferentAccess.new(YAML::load(ERB.new(File.read(file_path)).result)) || {}
        load_config(controllers)
      end

      # Registers browser drivers in Capybara from a configuration hash
      #@param config [String] configuration hash containing browser drivers
      #@since 2.1.0
      def load_config(config)
        config.each do |controller, options|
          raise InvalidConfigurationError.new "No browser defined for controller #{controller}" unless options['browser']
          register_controller(controller.to_sym, options)
        end
      end

      private

      def register_controller(controller, options)
        browser         = options['browser'].to_sym
        driver          = options['driver'] || mapping[browser]
        screen          = options['screen']
        properties      = options['properties']
        browser_options = options['options']
        addons          = options['addons']
        hooks           = options['hooks']

        if driver.to_sym == :poltergeist
          load_poltergeist_driver(browser, controller, screen)
        else
          load_generic_driver(browser, controller, screen, driver, properties, browser_options, addons, hooks)
        end
      end

      def require_hooks(hooks)
        if hooks&.any?
          if defined?(Cucumber)
            hooks.each do |hook|
              log.debug "Loading cucumber hook: qat/web/hooks/#{hook}"
              require "qat/web/hooks/#{hook}"
            end
          else
            log.debug "Running in a non-Cucumber runtime, skipping hooks!"
          end
        end
      end

      #Configuration load error class.
      class InvalidConfigurationError < StandardError
      end
    end
  end
end