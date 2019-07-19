require 'selenium-webdriver'
require 'selenium/webdriver/chrome/service'
require 'qat/logger'

module Selenium
  module WebDriver
    module Chrome
      class Service
        include QAT::Logger

        def stop
          log.info "Stopping Chrome process #{@process&.pid}"
          return if @process.nil? || @process.exited?

          Net::HTTP.start(@host, @port) do |http|
            http.open_timeout = STOP_TIMEOUT / 2
            http.read_timeout = STOP_TIMEOUT / 2

            http.get("/shutdown")
          end
        rescue ::Net::ReadTimeout
          log.warn "Could not stop process #{@process&.pid}"
        ensure
          stop_process
        end

      end
    end
  end
end