require_relative '../version'
require_relative 'loader'
require_relative 'wrapper'
require 'headless/core_ext/random_display'
require 'qat/logger'

module QAT::Web
  module Screen
    #Module to provide virtual screens for web control.
    #@since 1.0.0
    module Factory
      include QAT::Logger

      class << self
        #Method to ask for a virtual screen. It will be provided if {QAT::Web::Screen::Loader} knows the screen definition.
        #Will do nothing if +ENV ['QAT_DISPLAY'] + is set to +'none'+
        #@param name [String/Symbol] Name of the virtual screen to use
        #@return [QAT::Screen::Wrapper] current screen
        #@raise [ArgumentError] When a given screen definition does not exist.
        #@since 1.0.0
        def for name=:default, load=true

          name ||= :default

          name = name.to_sym

          unless QAT::Web::Screen::Loader.screens.has_key? name
            log.error { "No screen with name #{name} available" }
            log.debug { 'Available screens are:' }
            log.debug { QAT::Web::Screen::Loader.screens.keys }
            raise ArgumentError.new "No screen with name #{name} available"
          end

          current_screen.destroy if current_screen
          screen_definitions = QAT::Web::Screen::Loader.screens[name]
          if screen_definitions.empty?
            log.debug {'Using the default configuration definitions'}
            screen_definitions[:reuse] = false
          end
          self.current_screen =  QAT::Web::Screen::Wrapper.new name, screen_definitions

          if ENV['QAT_DISPLAY'] == 'none'
            log.info 'Virtual screens disabled'
          elsif not load
            log.info 'Virtual screen will not be loaded'
          else
            current_screen.start
          end

          current_screen
        end

        #Current screen in use
        #@return [QAT::Screen::Wrapper] current screen
        #@since 1.0.0
        def current_screen
          @current_screen ||= nil
        end

        private
        def current_screen= screen
          @current_screen = screen
        end
      end
    end

  end
end
