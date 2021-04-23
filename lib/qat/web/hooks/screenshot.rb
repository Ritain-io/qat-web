require_relative 'common'
require 'qat/web/exceptions'

module QAT::Web
  module Exceptions
    SCREENSHOT = GLOBAL.dup
  end
end

Before do |scenario|
  QAT::Web::Browser::Screenshot.screenshot_path = File.join('public', "#{QAT::Web::Hooks::Common.scenario_tag(scenario)}.png")
end

After do |scenario|
  if scenario.failed?
    if QAT::Web::Exceptions::SCREENSHOT.any? { |exception| scenario.exception.kind_of?(exception) }
      attach QAT::Web::Browser::Screenshot.take_screenshot, 'image/png'
    end
  end
end