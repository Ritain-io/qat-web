require 'fileutils'
require 'qat/logger'
require 'httparty'


Around '@selenium_headless' do |_, block|
  require 'selenium-webdriver'
  Headless.ly do
    Retriable.retriable on:            [Net::ReadTimeout, Selenium::WebDriver::Error::WebDriverError],
                        tries:         3,
                        base_interval: 5,
                        multiplier:    1.0,
                        rand_factor:   0.0 do
      block.call
    end
  end
end

Around do |_, block|
  Dir.mktmpdir do |dir|
    @tmpdir = dir
    block.call
  end
end

Around '@force_headless' do |_, block|
  old_qat_display = ENV['QAT_DISPLAY']
  log.info 'Forcing to use a headless screen (maybe due to video recording tests!).'
  ENV['QAT_DISPLAY'] = ''

  block.call

  ENV['QAT_DISPLAY'] = old_qat_display
end

#User Story #502: Capture webpage screenshot on test failure
After '@user_story#502' do
  QAT::Web::Browser::Screenshot.screenshot_path= nil
end

After '@user_story#505' do
  FileUtils.rm @html_dump_path if @html_dump_path
  QAT::Web::Browser::HTMLDump.html_dump_path = nil
end

Before '@chrome_pdf' do
  files = Dir.glob('/tmp/chrome/*.pdf')
  FileUtils.rm files if files.any?
end

After do
  if @old_screen_variable
    @old_screen_variable.destroy
  end

  if QAT::Web::Screen::Factory.current_screen
    QAT::Web::Screen::Factory.current_screen.destroy
    QAT::Web::Screen::Factory.instance_exec { @current_screen=nil }
  end

  Capybara.class_exec do
    unless session_pool.empty?
      if current_session.instance_variable_defined? :@driver and current_session.driver.respond_to? :quit
        current_session.driver.quit rescue Selenium::WebDriver::Error::WebDriverError
      end
      session_pool.delete "#{current_driver}:#{session_name}:#{app.object_id}"
    end
  end

  if Capybara.drivers
    Capybara.drivers.delete_if { |k, _| k.to_s =~ /^(?:custom|my)_/ }
  end

end

module Hooks
  module Sinatra
    include QAT::Logger
    extend self

    def sinatra_path
      @path ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'sinatra'))
    end

    def pid_filename
      @pid_file ||= "/tmp/sinatra_#{Time.now.to_i}.pid"
    end

    def sinatra_log_file
      unless @sinatra_log_file
        @sinatra_log_file ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public', 'sinatra.log'))
        File.open(@sinatra_log_file, 'w') {}
      end
      @sinatra_log_file
    end

    def start_app
      if File.exists? pid_filename
        begin
          Process.getpgid(File.read(pid_filename).to_i)
        rescue Errno::ESRCH
          log.warn 'PID file found but process does not exist...Removing File!'
          File.delete pid_filename
        end
      end

      unless File.exists? pid_filename
        log.info 'Sinatra server not running, starting a new one...'

        pid = nil
        FileUtils.cd sinatra_path do
          pid = Process.spawn 'rackup', [:out, :err] => sinatra_log_file
        end

        Process.detach(pid)
        File.open(pid_filename, 'w') { |file| file.write(pid.to_s) }
      end

      log.info "Running sinatra server with pid #{File.read pid_filename}"
      log.info "Waiting for server to finish startup"

      Retriable.retriable on:            [Errno::ECONNREFUSED],
                          tries:         30,
                          base_interval: 1,
                          multiplier:    1.0,
                          rand_factor:   0.0 do
        HTTParty.get 'http://localhost:8090'
        log.info "Server started"
      end

    rescue Errno::ECONNREFUSED
      log.error "Sinatra server failed to start!!!!"
      log.debug { File.read sinatra_log_file }
    end

    def stop_app
      pid = File.read(pid_filename).to_i

      log.info "Stoping sinatra: PID #{pid}"
      Process.kill("KILL", pid)

    rescue Errno::ESRCH
      log.warn "Process with PID #{pid} not found! Skipping..."
    ensure
      log.info "Sinatra stopped, removing #{pid_filename}."
      File.delete pid_filename
    end

  end
end

Around '@sinatra_mock' do |_, block|
  Hooks::Sinatra.start_app
  block.call
  Hooks::Sinatra.stop_app
end

