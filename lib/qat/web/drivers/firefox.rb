require 'capybara'
require_relative 'firefox/har_exporter'

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end