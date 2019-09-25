require_relative '../web/page'

module MODULO_NAME
  module MODULO_NAME
    class Home < MODULO_NAME::Web::Page
      include QAT::Logger

      elements_config QAT.configuration.dig(:web, :web, :home)

      web_elements :locator_name_example

      def initialize
        raise HomePageNotLoaded.new 'Home page was not loaded' unless has_selector? *selector_locator_name_example
        QAT::Reporter::Times.stop(:home_loading)
        log.info "Loaded home page with URL: #{current_url}"
      end

      private

      class HomePageNotLoaded < QAT::Web::Error
      end
    end
  end
end