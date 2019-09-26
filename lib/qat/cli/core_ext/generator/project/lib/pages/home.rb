require_relative '../web/page'

module ProjectName
  module Pages
    class Home < ProjectName::Web::Page
      include QAT::Logger

      elements_config QAT.configuration.dig(:web, :home)

      web_elements :locator_name_example

      def initialize
        raise HomePageNotLoaded.new 'Home page was not loaded!' unless has_selector? *selector_locator_name_example
        QAT::Reporter::Times.stop(:home_loading)
        log.info "Loaded home pages with URL: #{current_url}"
      end

      def input_search search_text
        locator_name_example.set search_text
      end

      private

      class HomePageNotLoaded < QAT::Web::Error
      end
    end
  end
end