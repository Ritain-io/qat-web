require 'qat/web/error'
require 'qat/web/exceptions'

module QAT::Web
  # Drivers namespace
  module Drivers
    # Module with drivers default for browsers.
    module Firefox
      class HarExporter
        TOKEN = 'qat_web_automation'

        EXCEPTIONS = QAT::Web::Exceptions::GLOBAL.dup
      end
    end
  end
end