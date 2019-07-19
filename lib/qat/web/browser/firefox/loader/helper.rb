module QAT::Web
  module Browser
    module Loader
      # Module with helper methods to load browsers and drivers from configuration files.
      #@since 2.0.1
      module Helper
        # Creates a generic Capybara driver
        # @param browser [String] Expected browser
        # @param controller [String] Expected controller
        # @param screen [String] Expected screen properties
        # @param driver [String] Expected driver
        # @param properties [String] Expected driver properties
        # @param addons [String] Expected driver/browser addons
        # @param hooks [String] Cucumber hooks to use
        # @return [Capybara::RackTest::Driver||Capybara::Selenium::Driver]
        def load_generic_driver(browser, controller, screen, driver, properties, addons, hooks)
          Capybara.register_driver controller do |app|
            loaded_screen = QAT::Web::Screen::Factory.for screen
            loaded_driver = nil
            Retriable.retriable on:            [Net::ReadTimeout, ::Selenium::WebDriver::Error::WebDriverError],
                                tries:         3,
                                base_interval: 5,
                                multiplier:    1.0,
                                rand_factor:   0.0 do

              options = { browser: browser }
              if properties
                customized_profile = create_profile(driver, browser, properties, addons)
                options.merge!(customized_profile) if customized_profile
              end
              loaded_driver = Capybara.const_get(driver.capitalize)::Driver.new(app, options)
              loaded_driver.browser
            end

            if loaded_screen.xvfb
              loaded_driver.resize_window_to(loaded_driver.current_window_handle, loaded_screen.width, loaded_screen.height)
            else
              loaded_driver.maximize_window(loaded_driver.current_window_handle) if loaded_driver.respond_to? :maximize_window
            end

            require_hooks(hooks)

            loaded_driver
          end
        end
      end
    end
  end
end