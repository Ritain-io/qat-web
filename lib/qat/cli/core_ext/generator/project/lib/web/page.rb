require 'capybara/dsl'
require 'qat/logger'
require 'qat/configuration'
require 'qat/web/page'
require 'qat/web/finders'
require 'active_support/core_ext/hash/indifferent_access'


module ProjectName
  module Web
    class Page < QAT::Web::Page
      include Capybara::DSL
      include QAT::Logger
      include QAT::Web::Finders

      # Action to navigate to your home page
      action :navigate_home!, returns: [ProjectName::Web::Page] do
        QAT::Reporter::Times.start(:home_loading)
        visit URI::Generic.build(QAT.configuration[:hosts][:home].symbolize_keys).to_s
        ProjectName::Pages::Home.new
      end
    end
  end
end
