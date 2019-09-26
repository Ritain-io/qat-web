require_relative 'page'
require_relative 'blank_page'
require 'qat/web/page_manager'

#Project name Module
module ProjectName::Web
  #Project name Module
  class PageManager < QAT::Web::PageManager
    manages ProjectName::Web::Page
    initial_page ProjectName::Web::BlankPage
  end
end