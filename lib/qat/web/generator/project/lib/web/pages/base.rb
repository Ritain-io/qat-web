require 'capybara/dsl'
require 'qat/logger'
require 'qat/configuration'
require 'qat/web/page'
require 'qat/web/finders'

#Project name Module
module ProjectName
  #Web name Module
  module Web
    #Page name Module
    module Pages
    #Class base
    class Base < QAT::Web::Pages
      include Capybara::DSL
      include QAT::Logger
      include QAT::Web::Finders

      # Action to navigate to your home page
      action :navigate_home!, returns: [ProjectName::Web::Pages::Base] do
        visit 'https://www.google.com'
        ProjectName::Pages::Home.new
      end
    end
      end
  end
end
