After do |scenario|
  if scenario.failed? and QAT::Web::Drivers::Firefox::HarExporter::EXCEPTIONS.include?(scenario.exception.class)

    begin
      log.info 'Saving HAR file'

      Retriable.retriable(on:            Selenium::WebDriver::Error::JavascriptError,
                          tries:         30,
                          base_interval: 5,
                          multiplier:    1,
                          rand_factor:   0,
                          on_retry:      (proc do |exception, _scenario, _duration, _try|
                            log.warn 'Error saving HAR!'
                            log.debug exception
                          end)) do
        result = Capybara.current_session.evaluate_script <<-JS
          HAR.triggerExport({
            token: '#{QAT::Web::Drivers::Firefox::HarExporter::TOKEN}',    // Value of the token in your preferences
            fileName: "http_requests_%d-%m-%yT%T",    // T%T True if you want to also get HAR data as a string in the callback
          }).then(result => {
              // The local file is available now, result.data is null since options.getData wasn't set.
          });
        JS
      end

      log.info "Saved HAR file in configured folder."
    rescue => e
      log.error 'Could not save HAR file:'
      log.error e
    end
  end
end
