require_relative 'pages'
require 'qat/web/page_manager'

#Project name Module
module ProjectName::Web
  #Class PageManager
  class PageManager < QAT::Web::PageManager
    manages ProjectName::Web::Pages::Base
    initial_page ProjectName::Web::Pages::Blank
  end
end