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
      embed(QAT::Web::Browser::HTMLDump.take_html_dump, 'text/plain', 'HTML dump')
    end
  end
end