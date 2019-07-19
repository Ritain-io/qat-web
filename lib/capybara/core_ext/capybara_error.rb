require 'capybara'
require_relative '../../../lib/qat/web/error/enrichment'
# Capybara extension
module Capybara
  # Capybara::CapybaraError extension
  class CapybaraError
    include Enrichment

    #@api private
    def initialize(msg)
      super(rich_msg(msg))
    end
  end
end