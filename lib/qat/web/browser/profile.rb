require 'capybara'
require 'qat/logger'

module QAT::Web
  module Browser
    # Module to provide browsers specific profile.
    module Profile
      include QAT::Logger

      ADDONS = {
        firefox: {
          har_exporter: 'harexporttrigger-0.5.0-beta.10.xpi'
        }
      }

      def create_profile (driver, browser, properties, addons)
        return nil unless properties && properties.any?
        begin
          method("#{driver}_#{browser}_profile".to_sym).call(properties, addons)
        rescue NoMethodError => exception
          if exception.message.match(/.*_.*_profile/)
            raise(HandlerNotImplemented, "A profile handler for driver '#{driver.capitalize}' and/or '#{browser.capitalize}' does not exist at this moment!")
          else
            raise
          end
        end
      end

      #@since 9.0.5
      def create_options (driver, browser, options)
        return nil unless options && options.any?
        begin
          method("#{driver}_#{browser}_options".to_sym).call(options)
        rescue NoMethodError => exception
          if exception.message.match(/.*_.*_options/)
            raise(HandlerNotImplemented, "An options handler for driver '#{driver.capitalize}' and/or '#{browser.capitalize}' does not exist at this moment!")
          else
            raise
          end
        end
      end

      private
      def selenium_firefox_profile(properties, addons)
        profile = selenium_profile(:firefox)

        profile = load_firefox_addons(profile, addons)

        profile = set_profile(profile, properties)

        { profile: profile }
      end

      def selenium_chrome_profile (properties, addons)
        profile = selenium_profile(:chrome)

        profile = set_profile(profile, properties)

        { prefs: profile.send(:prefs) }
      end

      def selenium_profile(browser)
        begin
          require 'selenium-webdriver'
        rescue LoadError => e
          if e.message =~ /selenium-webdriver/
            raise LoadError, "QAT-Web is unable to load `selenium-webdriver`, please install the gem and add `gem 'selenium-webdriver'` to your Gemfile if you are using bundler."
          else
            raise e
          end
        end
        Selenium::WebDriver.const_get(browser.capitalize)::Profile.new
      end

      def set_profile(profile, properties)
        properties.each { |name, changes| profile[name] = changes }
        profile
      end

      def load_firefox_addons(profile, addons)

        addons.each do |addon|
          path = if File.exist?(addon)
                   File.realpath(addon)
                 elsif ADDONS[:firefox][addon.to_sym]
                   File.expand_path(File.join(File.dirname(__FILE__), "firefox", ADDONS[:firefox][addon.to_sym]))
                 else
                   raise(InvalidAddonError, "Addon #{addon} could not be loaded!")
                 end

          log.debug "Loading Firefox addon from '#{path}'"

          profile.add_extension(path)
        end if addons&.any?


        profile
      end

      def selenium_firefox_options(browser_options)
        options = selenium_options(:firefox)
        options = set_options(options, browser_options)
        { options: options }
      end

      def selenium_chrome_options(browser_options)
        options = selenium_options(:chrome)
        options = set_options(options, browser_options)
        { options: options }
      end

      def selenium_options(browser)
        begin
          require 'selenium-webdriver'
        rescue LoadError => e
          if e.message =~ /selenium-webdriver/
            raise LoadError, "QAT-Web is unable to load `selenium-webdriver`, please install the gem and add `gem 'selenium-webdriver'` to your Gemfile if you are using bundler."
          else
            raise e
          end
        end
        Selenium::WebDriver.const_get(browser.capitalize)::Options.new
      end

      def set_options(options, browser_options)
        browser_options['args'].each { |arg| options.add_argument(arg) }
        browser_options['preferences'].each { |name, value| options.add_preference(name, value) }
        options
      end

      class HandlerNotImplemented < StandardError
      end
      class InvalidAddonError < StandardError
      end
    end
  end
end