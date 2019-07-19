require_relative 'version'
require_relative 'drivers'
require_relative 'browser/factory'
require_relative 'browser/loader'
require_relative 'browser/screenshot'
require_relative 'browser/html_dump'
require_relative 'browser/profile'

require 'qat/logger'

module QAT::Web::Browser
  include QAT::Logger

  class << self
    #Prints the current browser URL
    #@since 1.2.0
    def print_url
      log.info "The current URL is #{Capybara.current_session.current_url}"
    end
  end
end