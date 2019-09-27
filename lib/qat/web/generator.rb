require_relative '../../../lib/qat/web/version'
require 'fileutils'
module QAT::Web
  #Module for the various generators used in the CLI utility
  #@since 6.1.0
  module Generator
    include FileUtils
    extend FileUtils

    # Adds a files QAT Web module to the current project
    def add_module(stdout, opts)

      stdout.puts "Adding files to project" if opts[:verbose]
      cp_r ::File.join(::File.dirname(__FILE__), 'generator', 'project', '.'), Dir.pwd, opts
      ::File.write('Gemfile', <<-GEMFILE, mode: 'a')
      


# QAT-Web is a browser controller for Web testing (https://github.com/readiness-it/qat-web)
gem 'qat-web', '~> 6.0'

# Ruby headless display interface (http://leonid.shevtsov.me/en/headless)
gem 'headless' #optional

# The next generation developer focused tool for automated testing of webapps (https://github.com/seleniumhq/selenium)
gem 'selenium-webdriver' #optional
      GEMFILE
    end

    module_function :add_module
  end
end