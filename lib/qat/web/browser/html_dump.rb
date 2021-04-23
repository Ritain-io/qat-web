require_relative '../version'
require 'capybara'
require 'qat/logger'

module QAT::Web
  # Browser namespace
  module Browser
    # Module to handle browser HTML dumps.
    #@since 1.0.0
    module HTMLDump
      include QAT::Logger
      extend self

      # Function to take a browser HTML dump. Will handle the usage of driver that don't support HTML dumps.
      #@param page [Capybara::Session] Browser to take HTML dump from
      #@param path [String] File path to save HTML dump file
      #@return [String/NilClass] File path to where the HTML dump file was saved or nil if the browser doesn't support HTML dumps
      #@since 1.0.0
      def take_html_dump(page=Capybara.current_session, path=html_dump_path)
        log.info { "Saving HTML dump to #{path}" }
        raise ArgumentError.new "File #{path} already exists! Choose another filename" if ::File.exists? path
        file = page.save_page path
        file_read = File.open file
        path = file_read.read
        log.info { "HTML dump available" }
        path
      rescue Capybara::NotSupportedByDriverError
        log.warn { "Driver #{page.mode} does not support HTML dumps!" }
        return nil
      end

      #Default HTML dump path. Can be set with {#html_dump_path=}.
      #@return [String] HTML dump path
      #@since 1.0.0

      def html_dump_path
        @html_dump_path || ::File.join('public', "browser_#{Time.new.strftime("%H%M%S%L")}.html")
      end

      #Set new default HTML dump path.
      #@param path [String] HTML dump path
      #@since 1.0.0
      def html_dump_path=(path)
        @html_dump_path = path
      end

    end
  end
end