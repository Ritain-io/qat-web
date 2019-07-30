require_relative '../iana/domains/reserved'

module WebTests
  module Example
    class Page < WebTests::Page
      include QAT::Logger

      elements_config QAT.configuration.dig(:web, :example, :page)

      web_elements :header, :more_info_link

      web_collection :body_paragraphs, elements[:locators][:body_paragraphs]

      def initialize(opts={})
        visit_page elements[:url] if opts[:force]
      end

      get_value :header_text do
        log.info { "Getting header text..." }
        header.text
      end

      get_value :body_text do
        log.info { "Getting body text..." }
        body_paragraphs.first.text
      end

      action :click_more_info!, returns: [::WebTests::Page] do
        log.info { "Clicking more info..." }
        wait_until_present(extract_selector(config_more_info_link), 5)
        more_info_link.click
        ::WebTests::IANA::Domains::Reserved.new
      end
    end
  end
end