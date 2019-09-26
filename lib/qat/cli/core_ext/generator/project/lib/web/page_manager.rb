require_relative 'page'
require_relative 'blank_page'
require 'qat/web/page_manager'

module ProjectName::Web
  class PageManager < QAT::Web::PageManager
    manages ProjectName::Web::Page
    initial_page ProjectName::Web::BlankPage
  end
end