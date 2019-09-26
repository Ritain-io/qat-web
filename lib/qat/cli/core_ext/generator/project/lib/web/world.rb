require_relative 'page_manager'
require_relative '../pages/home'

require_relative 'remote_driver'

QAT::Web::Browser::AutoLoad.load_browsers!
QAT::Web::Screen::AutoLoad.load_screens!

module ProjectName
  module Web
    module World

      def browser
        unless @browser
          QAT::Web::Browser::Factory.for :remote_firefox
          @browser = ProjectName::Web::PageManager.new
        end
        @browser
      end

    end
  end
end