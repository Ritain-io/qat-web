require_relative '../version'
require 'qat/logger'
require 'active_support'
require 'active_support/hash_with_indifferent_access'
require 'active_support/core_ext/hash/indifferent_access'

module QAT::Web
  #Namespace for virtual screen management
  #@since 1.0.0
  module Screen
    #Utility methods to load screen definitions from configuration files
    #@since 1.0.0
    module Loader
      include QAT::Logger

      class << self
        # include QAT::Logger
        # Registers screen definitions from a YAML file
        #@param filepath [String] file containing screen definitions
        #@raise [QAT::Web::Screen::Loader::InvalidConfigurationError] When an incorrect configuration is found
        #@since 1.0.0
        def load(filepath)
          log.info { "Opening #{filepath}" }

          screens = HashWithIndifferentAccess.new(YAML::load(ERB.new(File.read(filepath)).result)) || {}

          load_config(screens)

          log.info { "File #{filepath} parsed" }
        end

        # include QAT::Logger
        # Registers screen definitions from a configuration hash
        #@param config [Hash] configuration hash containing screen definitions
        #@raise [QAT::Web::Screen::Loader::InvalidConfigurationError] When an incorrect configuration is found
        #@since 2.1.0
        def load_config(config)
          config.each(&method(:load_screen))
        end

        # include QAT::Logger
        # Registers a screen definition
        #@param name [String] screen name
        #@param options [String] screen definitions
        #@raise [QAT::Web::Screen::Loader::InvalidConfigurationError] When an incorrect configuration is found
        #@since 2.1.0
        def load_screen(name, options={})
          if name.is_a?(Array)
            log.debug { "Parsing #{name.first}" }
            parsed_opts = name.last.dup rescue {}
            
            raise InvalidConfigurationError.new "Configuration for screen #{name} is empty!" unless parsed_opts&.any?
            
            parse_resolution name.first, parsed_opts
            
            self.screens[name.first.to_sym] = parsed_opts
            log.debug { "Parsed #{name.first}" }
          else
            log.debug { "Parsing #{name.first}" }
            parsed_opts = options.dup rescue {}
            
            raise InvalidConfigurationError.new "Configuration for screen #{name} is empty!" unless parsed_opts&.any?
            
            parse_resolution name, parsed_opts
            
            self.screens[name.to_sym] = parsed_opts
            log.debug { "Parsed #{name}" }
          end
          
        end

        #List of known virtual screen definitions
        #@return [Hash] list of screen definitions
        #@since 1.0.0
        def screens
          @screens ||= { default: {} }
        end

        private

        def parse_resolution(name, options)
          raise InvalidConfigurationError.new "No resolution defined for screen #{name}" unless options['resolution']

          res = options.delete 'resolution'

          mandatory_param_check = proc { |key| raise InvalidConfigurationError.new "No mandatory key #{key} in resolution of screen #{name}" }

          height = res.fetch 'height', &mandatory_param_check
          width  = res.fetch 'width', &mandatory_param_check
          depth  = res.fetch 'depth', 24

          dim = [width, height, depth].join('x')

          log.debug { "Using #{dim} resolution for screen #{name}" }

          options[:dimensions] = dim
        end

      end
      #Configuration load error class.
      class InvalidConfigurationError < StandardError
      end

    end
  end
end