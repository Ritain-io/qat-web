module WebTests
  module IANA
    module Domains
      class Reserved < WebTests::Page
        include QAT::Logger

        elements_config QAT.configuration.dig(:web, :iana, :domains, :reserved)

        web_element :header

        def initialize(opts={})
          visit_page elements[:url] if opts[:force]
        end

        get_value :header_text do
          log.info { "Getting header text..." }
          header.text
        end
      end
    end
  end
end