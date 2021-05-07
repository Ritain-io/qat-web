require_relative 'common'
require 'qat/web/exceptions'

module QAT::Web
  module Exceptions
    HTML_DUMP = GLOBAL.dup
  end
end

Before do |scenario|
  QAT::Web::Browser::HTMLDump.html_dump_path    = File.join('public', "#{QAT::Web::Hooks::Common.scenario_tag(scenario)}.html")
end

After do |scenario|
  if scenario.failed?
    if QAT::Web::Exceptions::HTML_DUMP.any? { |exception| scenario.exception.kind_of?(exception) }
      # Embeds an existing HTML dump to Cucumber's HTML report
      # This attach the content of the file in this case the attach method appears it doesn't allow atm to embed a file link as before
      # attach(QAT::Web::Browser::HTMLDump.take_html_dump, 'text/html')
      # Only saving the content to the public folder
       QAT::Web::Browser::HTMLDump.take_html_dump
    end
  end
end