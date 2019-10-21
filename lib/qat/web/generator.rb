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
      has_gem_QATWEB = verify_gems path, 'qat-web', verbose: opts[:verbose]
      puts has_gem_QATWEB
      if has_gem_QATWEB
        puts "Module already integrated"
      else
        add_gem_dependency path, 'qat-web', verbose: opts[:verbose], version: QAT::Web::VERSION
        add_gem_dependency path, 'headless', verbose: opts[:verbose]
        add_gem_dependency path, 'selenium-webdriver', verbose: opts[:verbose]
        cp_r ::File.join(::File.dirname(__FILE__), 'generator', 'project', '.'), Dir.pwd, opts
      end
    end

    def verify_gems (gemfile_path, gem, opts = {})
      file = File.read(gemfile_path)
      gemfile = Gemnasium::Parser.gemfile(file)
      dependencies = gemfile.dependencies
      found_gem = dependencies.find {|i| i.name == gem}
      puts found_gem
      puts "gem #{gem} found? #{!found_gem.nil?}" if opts[:verbose]
      if found_gem
        return true
      else
        return false
      end
    end

    def add_gem_dependency (gemfile_path, gem, opts = {})
      version = opts[:version]
      line = "\n\ngem '#{gem}'#{version ? ", '>= #{version}'" : ''}"
      puts "adding dependencies #{gem} to Gemfile" if opts[:verbose]
      write_to_gemfile gemfile_path, line
    end


    def write_to_gemfile filename, line
      ::File.write(filename, line, mode: 'a')
    end

    module_function :add_module, :write_to_gemfile, :add_gem_dependency, :verify_gems
  end
end