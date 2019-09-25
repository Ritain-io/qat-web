require 'capybara'
require 'selenium-webdriver'

Capybara.register_driver :remote_firefox do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 300
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile["webdriver.load.strategy"] = 'eager'
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 http_client: client,
                                 profile: profile,
                                 url: ENV['SELENIUM_HUB_URL'], #'http://localhost:4444',
                                 desired_capabilities: Selenium::WebDriver::Remote::Capabilities.new).tap do |driver|
    driver.browser.manage.window.resize_to(1920, 1080)
  end
end