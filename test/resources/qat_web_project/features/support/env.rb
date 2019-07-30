# Code coverage
require 'minitest'
require 'simplecov'
require 'qat/configuration'
require 'qat/web/cucumber'

require 'selenium-webdriver'
require_relative '../../lib/web'

QAT::Web::Browser::AutoLoad.load_browsers!
QAT::Web::Screen::AutoLoad.load_screens!

ENV['FIREFOX_PATH']&.tap do |path|
  puts "Using firefox '#{path}'"
  Selenium::WebDriver::Firefox::Binary.path = path
end

QAT::Web::Browser::Factory.for ENV['QAT_WEB_BROWSER_PROFILE'] || 'video_browser'

module WebTests
  class Cucumber
    include QAT::Logger
    include Minitest::Assertions

    attr_accessor :assertions

    # @!attribute assertions
    #   @return [Integer] Counter of assertions for Minitest integration.
    def assertions
      @assertions ||= 0
    end

    def browser
      unless @browser
        QAT::Web::Browser::Factory.for ENV['QAT_WEB_BROWSER_PROFILE'] || 'video_browser'
        @browser = ::WebTests::PageManager.new
      end

      @browser
    end
  end
end

World { ::WebTests::Cucumber.new }
