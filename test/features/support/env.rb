# -*- encoding : utf-8 -*-
# Code coverage
require 'simplecov'

require 'minitest'
require 'headless/core_ext/random_display'
require 'tmpdir'
require 'yaml'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/hash/indifferent_access'
require "active_support/inflector"

require 'qat/configuration'
require 'selenium-webdriver'
require 'qat/web/cucumber'
require 'qat/logger'

require 'aruba/cucumber'

require 'nokogiri'
require 'retriable'

Capybara.server = :webrick

ENV['FIREFOX_PATH']&.tap do |path|
  puts "Using firefox '#{path}'"
  Selenium::WebDriver::Firefox::Binary.path = path
end

Aruba.configure do |config|
  config.exit_timeout    = 120
  config.io_wait_timeout = 2
end

module Test
  include QAT::Logger
  include Minitest::Assertions

  attr_writer :assertions

  def assertions
    @assertions ||= 0
  end
end
World Test

require_relative '../../lib/selenium_patch'
require_relative '../../lib/core_ext'
require_relative '../../lib/env_vars_world'
require_relative '../../lib/example_page'
require_relative '../../lib/gmail_page'
