require_relative 'page_manager'

QAT::Web::Browser::AutoLoad.load_browsers!
QAT::Web::Screen::AutoLoad.load_screens!

#Project name Module
module ProjectName
  #Project name Module
  module Web
    #Project name Module
    module World
      #Initialise browser
      def browser
        unless @browser
          QAT::Web::Browser::Factory.for :firefox
          @browser = ProjectName::Web::PageManager.new
        end
        @browser
      end

    end
  end
end