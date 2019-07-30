require 'qat/web/page_manager'
require 'qat/logger'
require_relative 'page'
require_relative 'blank_page'

module WebTests
  class PageManager < QAT::Web::PageManager
    include QAT::Logger

    manages ::WebTests::Page
    initial_page ::WebTests::BlankPage
  end
end