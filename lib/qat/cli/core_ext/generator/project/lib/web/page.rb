require 'capybara/dsl'
require 'qat/logger'
require 'qat/configuration'
require 'qat/web/page'
require 'qat/web/finders'
require 'active_support/core_ext/hash/indifferent_access'


module MODULO_NAME
  module Web
    class Page < QAT::Web::Page
      include Capybara::DSL
      include QAT::Logger
      include QAT::Web::Finders

      # Add action to navigate to home page
    end
  end
end
