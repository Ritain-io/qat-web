require_relative '../version'
require_relative 'loader'
require 'headless/core_ext/random_display'
require 'qat/logger'

module QAT::Web
  module Screen

    #Screen wrapper to represent an abstract display. Can have a Headless instance associated.
    #@since 1.0.0
    class Wrapper
      include QAT::Logger

      #@return [String] Screen name
      #@since 1.0.0
      attr_reader :name

      #@return [Hash] Initialization options
      #@since 1.0.0
      attr_reader :options

      #@return [String] Screen width
      #@since 1.0.0
      attr_reader :width

      #@return [String] Screen height
      #@since 1.0.0
      attr_reader :height

      #@return [String] Screen depth
      #@since 1.0.0
      attr_reader :depth

      #@return [Headless] Xvfb instance representing the screen
      #@since 1.0.0
      attr_reader :xvfb

      #Create a new screen.
      #@param name [String] screen name
      #@param options [Hash] start options
      #@option options [String] :dimensions Screen dimensions ('800x600x24')
      #@since 1.0.0
      def initialize name, options
        @name    = name
        @options = options
        parse_resolution options
        log.info "Created screen with #{width}x#{height}x#{depth}"
        @xvfb = nil
      end

      #Start a new Xvfb instance
      #@return [Headless] Xvfb instance
      #@since 1.0.0
      def start
        @xvfb = Headless.new @options
        @xvfb.start
        log.info "Xvfb #{name} screen started"
        @xvfb
      end

      #Destroy the Xvfb instance
      #@since 1.0.0
      def destroy
        return unless @xvfb
        @xvfb.destroy
        log.info "Xvfb #{name} screen destroyed"
        @xvfb = nil
      end

      #Redirect all unknown methods to the Xvfb instance
      #@since 1.0.0
      def method_missing method, *args, &block
        @xvfb.method(method).call *args, &block
      end

      private

      def parse_resolution options
        options[:dimensions] ||= '800x600x24'

        @width, @height, @depth = options[:dimensions].split 'x'
        @depth                  ||= 24
      end
    end

  end
end