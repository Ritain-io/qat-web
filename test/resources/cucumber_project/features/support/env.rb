# Code coverage
require 'simplecov'
require 'qat/logger'
require 'qat/web/cucumber'
require 'selenium-webdriver'
require 'minitest'

module Tests
  class Cucumber
    include QAT::Logger
    include Minitest::Assertions

    attr_writer :assertions

    def assertions
      @assertions ||= 0
    end

    ENV['FIREFOX_PATH']&.tap do |path|
      log.info "Using firefox '#{path}'"
      Selenium::WebDriver::Firefox::Binary.path = path
    end
  end
end

Capybara.register_driver :firefox_headless do |app|
  options = ::Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.javascript_driver = :firefox_headless

World { ::Tests::Cucumber.new }
