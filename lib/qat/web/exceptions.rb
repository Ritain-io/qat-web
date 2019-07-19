require 'capybara'
require 'qat/web/error'

module QAT::Web
  module Exceptions
    GLOBAL = [
      QAT::Web::Error,
      Capybara::CapybaraError
    ]
  end
end

if defined?(Selenium)
  QAT::Web::Exceptions::GLOBAL << Selenium::WebDriver::Error::WebDriverError
end