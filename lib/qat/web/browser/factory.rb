require 'capybara'
require 'qat/logger'

module QAT::Web
  # Browser namespace
  module Browser
    # Module to provide browsers and drivers for web control.
    #@since 1.0.0
    module Factory
      include QAT::Logger

      #Method to ask for a browser. It will be provided if Capybara has a driver with that name
      #@param browser [String/Symbol] Name of the Capybara::Driver to use
      #@raise [ArgumentError] When a given driver does not exist.
      #@since 1.0.0
      def self.for browser
        browser = browser.to_sym

        unless Capybara.drivers.has_key? browser
          log.error { "No driver with name #{browser} available" }
          log.debug { 'Available drivers are:' }
          log.debug { Capybara.drivers.keys }
          raise ArgumentError.new "No driver with name #{browser} available"
        end

        if Capybara.current_driver != browser
          log.info { "Switching from #{Capybara.current_driver} to #{browser}" }
          Capybara.current_driver    = browser
          Capybara.default_driver    = browser
          Capybara.javascript_driver = browser
        end
        #Force driver start
        Capybara.current_session.driver
        Capybara.current_session
      end

    end
  end
end