#encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'qat-web'
  gem.version     = '7.0.0'
  gem.summary     = %q{QAT-Web is a browser controller for Web testing}
  gem.description = <<-DESC
  QAT-Web is a browser controller for Web testing, with support for various browsers and webdrivers.
  Includes various classes for easier planning and implementation of web interactions, using the Page Objects Pattern.
  DESC
  gem.email    = 'qatoolkit@readinessit.com'
  gem.homepage = 'https://www.readinessit.com'

  gem.metadata    = {
      'source_code_uri'   => 'https://github.com/readiness-it/qat-web'
  }

  gem.authors = ['QAT']
  gem.license = 'GPL-3.0'

  gem.files = Dir.glob('{lib}/**/*')

  gem.required_ruby_version = '~> 2.5'

  # Development dependencies
  gem.add_development_dependency 'qat-cucumber', '~> 7.0'
  gem.add_development_dependency 'qat-devel', '~> 8.0'
  gem.add_development_dependency 'headless', '~> 2.3', '>= 2.3.1'
  gem.add_development_dependency 'sinatra', '~> 1.4', '>= 1.4.6'
  gem.add_development_dependency 'syntax', '~> 1.2'
  gem.add_development_dependency 'httparty', '~> 0.14.0'
  gem.add_development_dependency 'selenium-webdriver'

  # GEM dependencies
  gem.add_dependency 'qat-logger', '~> 8.0'
  gem.add_dependency 'little-plugger', '~> 1.1', '>= 1.1.4'
  gem.add_dependency 'capybara'
  gem.add_dependency 'retriable'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'gemnasium-parser'
end
