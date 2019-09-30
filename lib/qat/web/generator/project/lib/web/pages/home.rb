require_relative 'base'

#Project name Module
module ProjectName
  #Web name Module
  module Web
    #Page Object Pages
    module Pages
      #Home page
      class Home < ProjectName::Web::Pages::Base
        include QAT::Logger

        elements_config QAT.configuration.dig(:qat, :web, :home)

        web_elements :locator_name_example

        def initialize
          raise HomePageNotLoaded.new 'Home page was not loaded!' unless has_selector? *selector_locator_name_example
          log.info "Loaded home page with URL: #{current_url}"
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
end