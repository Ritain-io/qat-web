# -*- encoding : utf-8 -*-
############################################
# Requires for your code libraries go here #
############################################
require 'selenium-webdriver'
require 'qat/cucumber'
require 'qat/configuration'
require 'qat/web'
require 'qat/web/cucumber'
require_relative '../../lib/web/world'
require 'qat/core_ext/integer'

World ProjectName::Web::World

ENV['FIREFOX_PATH']&.tap do |path|
  Selenium::WebDriver::Firefox::Binary.path = path
end