require 'capybara'

Capybara.register_driver :edge do |app|
  Capybara::Selenium::Driver.new(app, browser: :edge)
end
