require 'capybara/cucumber'
require_relative '../web'
require_relative 'hooks/html_dump'
require_relative 'hooks/screenshot'
require 'active_support'
require 'active_support/core_ext/string/inflections'

World QAT::Web::Finders

After do |scenario|
  if scenario.failed?
    if QAT::Web::Exceptions::GLOBAL.any? { |exception| scenario.exception.kind_of?(exception) }
      QAT::Web::Browser.print_url
    end
  end

  # Resets the configuration's access registry after each scenario
  QAT::Web::Configuration.last_access = nil
end