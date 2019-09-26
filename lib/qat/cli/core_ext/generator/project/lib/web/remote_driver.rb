require 'capybara'
require 'qat/configuration'
require 'selenium-webdriver'
require 'active_support/core_ext/hash/compact'
require 'retriable'
require 'qat/logger'

log = Log4r::Logger.new "Capybara.register_driver"
log.outputters = Log4r::Outputter[QAT::Logger::DEFAULT_OUTPUTTER_NAME]


Capybara.register_driver :firefox do |app|
  loaded_driver, loaded_screen = nil, nil
  max_tries = 10
  Retriable.retriable on: Selenium::WebDriver::Error::WebDriverError,
                      tries: max_tries,
                      on_retry: (proc do |error, try, _, _|
                        log.warn 'An error ocurred when loading the browser:'
                        log.warn error
                        if try < max_tries
                          log.debug 'Retrying'
                          loaded_screen&.destroy
                        else
                          log.error 'No more tries available, reraising error'
                        end
                      end) do

    if ENV['FIREFOX_PATH']
      log.debug "FIREFOX_PATH ='#{ENV['FIREFOX_PATH']}'"
      Selenium::WebDriver::Firefox::Binary.path = ENV['FIREFOX_PATH']
    end

    loaded_screen = Retriable.retriable on: Headless::Exception,
                                        on_retry: (proc do |error, try, _, _|
                                          log.warn 'An error ocurred when loading the headless screen:'
                                          log.warn error
                                          if try < Retriable.config.tries
                                            log.debug 'Retrying'
                                          else
                                            log.error 'No more tries available, reraising error'
                                          end
                                        end) do
      QAT::Web::Screen::Factory.for 'screen_1080p'
    end


    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['webdriver.load.strategy'] = 'eager'
    profile['geo.enabled'] = false
    capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(accept_insecure_certs: true)
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 180
    loaded_driver = Capybara::Selenium::Driver.new app,
                                                   http_client: client,
                                                   browser: :firefox,
                                                   profile: profile,
                                                   desired_capabilities: capabilities
    loaded_driver.browser
  end

  if loaded_screen.xvfb
    loaded_driver.resize_window_to(loaded_driver.current_window_handle, loaded_screen.width, loaded_screen.height)

    # Uncomment if using qat-web-video:
    # if ENV['QAT_WEB_VIDEO_MODE'] and ['always', 'success', 'failure'].include? ENV['QAT_WEB_VIDEO_MODE']
    #   loaded_screen.start_video_capture
    # end
  else
    loaded_driver.maximize_window(loaded_driver.current_window_handle) if loaded_driver.respond_to? :maximize_window
  end

  loaded_driver

end