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
      #novo codigo aqui
      gemfile = Gemnasium::Parser.gemfile(gemfileProject)
      version = QAT::Web::VERSION
      gem = 'qat-web'

      add_gem_dependency gemfile, gem, version, opts
    end

    def add_gem_dependency gemfile, gem, version = nil, opts
      b = gemfile.dependencies # unless b.find{|i| i.name == 'qat-cucumber'}
      c = b.find{|i| i.name == 'qat-web'}
      puts c

      if c
        add_gems_gemfile opts
      else
        a = "gem '#{gem}#{version ? "', '>= #{version}'" : ''}\n"
        add_gem_qat_web_gemfile a, opts
      end
    end

    def add_gem_qat_web_gemfile a, opts

      cp_r ::File.join(::File.dirname(__FILE__), 'generator', 'project', '.'), Dir.pwd, opts
      ::File.write('Gemfile', <<-GEMFILE, mode: 'a')
      

# QAT-Web is a browser controller for Web testing (http://gitlab.readinessit.com:8083/qa-toolkit/qat-web)
#{a}
      GEMFILE
      add_gems_gemfile opts
    end

    def add_gems_gemfile opts

      cp_r ::File.join(::File.dirname(__FILE__), 'generator', 'project', '.'), Dir.pwd, opts
      ::File.write('Gemfile', <<-GEMFILE, mode: 'a')

# Ruby headless display interface (http://leonid.shevtsov.me/en/headless)
gem 'headless' #optional

# The next generation developer focused tool for automated testing of webapps (https://github.com/seleniumhq/selenium)
gem 'selenium-webdriver' #optional
      GEMFILE
    end

    module_function :add_module, :add_gem_qat_web_gemfile, :add_gems_gemfile, :add_gem_dependency
  end
end