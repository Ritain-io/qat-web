require_relative 'base'

#Project name Module
module ProjectName
  #Page Object Pages
  module Pages
    #Home page
    class Home < ProjectName::Web::Pages::Base
      include QAT::Logger

      elements_config QAT.configuration.dig(:qat, :web, :home)

      web_elements :locator_name_example

      def initialize
        raise HomePageNotLoaded.new 'Home page was not loaded!' unless has_selector? *selector_locator_name_example
        QAT::Reporter::Times.stop(:home_loading)
        log.info "Loaded home pages with URL: #{current_url}"
      end

      #Introduce text on search box
      def input_search search_text
        locator_name_example.set search_text
      end

      private
      #Exception class error
      class HomePageNotLoaded < QAT::Web::Error
      end
    end
  end
end