require 'qat/logger'

require_relative 'page'
require_relative 'example'
require_relative 'iana'

module WebTests
  class BlankPage < WebTests::Page
    include QAT::Logger

    action :goto_example!, returns: [::WebTests::Page] do
      ::WebTests::Example::Page.new(force: true)
    end

    action :goto_iana!, returns: [::WebTests::Page] do
      ::WebTests::IANA::Homepage.new(force: true)
    end
  end
end