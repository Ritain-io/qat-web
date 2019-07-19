require_relative '../version'
require 'capybara'
require 'qat/logger'

module QAT::Web
  # Browser namespace
  module Browser
    #Module to handle browser screenshots.
    #@since 1.0.0
    module Screenshot
      include QAT::Logger
      extend self

      #Function to take a browser screenshot. Will handle the usage of driver that don't support screenshots.
      #@param page [Capybara::Session] Browser to take screenshot from
      #@param path [String] File path to save screenshot file
      #@return [String/NilClass]File path to where the screenshot file was saved or nil if the browser doesn't support screenshots
      #@since 1.0.0
      def take_screenshot page=Capybara.current_session, path=screenshot_path
        log.info {"Saving screenshot to #{path}"}
        raise ArgumentError.new "File #{path} already exists! Choose another filename" if ::File.exists? path
        path = page.save_screenshot path
        log.info {"Screenshot available"}
        path
      rescue Capybara::NotSupportedByDriverError
        log.warn {"Driver #{page.mode} does not support screenshots!"}
        return nil
      end

      #Default screenshot path. Can be set with {#screenshot_path=}.
      #@return [String] Screenshot path
      #@since 1.0.0
      def screenshot_path
        @screenshot_path || ::File.join('public', "browser_#{Time.new.strftime("%H%M%S%L")}.png")
      end

      #Set new default screenshot path.
      #@param value [String] Screenshot path
      #@since 1.0.0
      def screenshot_path= value
        @screenshot_path = value
      end

    end
  end
end