require_relative '../../../lib/qat/web/version'
require 'fileutils'
require 'gemnasium/parser'

module QAT::Web
  #Module for the various generators used in the CLI utility
  #@since 6.1.0
  module Generator
    include FileUtils
    extend FileUtils
    # Adds a files QAT Web module to the current project
    def add_module(stdout, opts)

      stdout.puts "Adding files to project" if opts[:verbose]


      # Read GemFile of new project
      path = File.join(Dir.pwd, 'Gemfile')
      gemfileProject = File.read(path)
      gemfile = Gemnasium::Parser.gemfile(gemfileProject)
      gemfiledependencias = gemfile.dependencies
      has_qat_web = false
      gemfiledependencias.each do |x|
        has_qat_web = true if x.name.eql? 'qat-web'
      end

      # ADD gem to GemFile depending on what is in the GemFile of project

      if has_qat_web == false
        cp_r ::File.join(::File.dirname(__FILE__), 'generator', 'project', '.'), Dir.pwd, opts
        ::File.write('Gemfile', <<-GEMFILE, mode: 'a')
      

# QAT-Web is a browser controller for Web testing (https://github.com/readiness-it/qat-web)
gem 'qat-web', '~> 6.1'
        GEMFILE
      end

      cp_r ::File.join(::File.dirname(__FILE__), 'generator', 'project', '.'), Dir.pwd, opts
      ::File.write('Gemfile', <<-GEMFILE, mode: 'a')
      

# Ruby headless display interface (http://leonid.shevtsov.me/en/headless)
gem 'headless' #optional

# The next generation developer focused tool for automated testing of webapps (https://github.com/seleniumhq/selenium)
gem 'selenium-webdriver' #optional
      GEMFILE
    end

    module_function :add_module
  end
end