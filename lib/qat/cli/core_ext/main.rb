require 'qat/cli'
#require_relative '../cucumber/version'
# require_relative 'generator'
# require 'optparse'
# require 'fileutils'
# require 'time'


class QAT::CLI::Main
  #include QAT::CLI::Generator

  def parse_argv!
    @argv = ['-h'] if @argv.empty?

    opts = OptionParser.new do |parser|
      parser.banner = 'Usage: qat-web [Options]'
      parser.separator 'Options'

      project_options(parser)
    end

    opts.parse!(@argv)
  end

  def project_options(parser)
    parser.on('-n', '--new [NAME]', String, 'Create new project') do |project|
      @options[:project] = project
    end
  end

end
