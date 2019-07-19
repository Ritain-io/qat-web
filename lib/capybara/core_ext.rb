require 'capybara'
require_relative 'core_ext/capybara_error'
require_relative 'core_ext/node/element'

if defined?(Selenium::WebDriver)
  require_relative 'core_ext/selenium/node'
end