require 'capybara/dsl'
require 'qat/web/page'
require 'qat/web/finders'
require 'qat/logger'

module WebTests
  class Page < QAT::Web::Page
    include Capybara::DSL
    include QAT::Logger
    include QAT::Web::Finders

    def visit_page(url)
      log.info { "Opening #{url}" }
      visit url
    end
  end
end