require_relative 'page'
require_relative 'blank_page'
require 'qat/web/page_manager'

module MODULO_NAME::Web
  class PageManager < QAT::Web::PageManager
    manages YOURROJECT::Web::Page
    initial_page YOURROJECT::Web::BlankPage
  end
end