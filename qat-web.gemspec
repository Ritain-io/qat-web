#encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'qat-web'
  gem.version     = '9.0.5'
  gem.summary     = %q{QAT-Web is a browser controller for Web testing}
  gem.description = <<-DESC
  QAT-Web is a browser controller for Web testing, with support for various browsers and webdrivers.
  Includes various classes for easier planning and implementation of web interactions, using the Page Objects Pattern.
  DESC
  gem.email    = 'qatoolkit@readinessit.com'
  gem.homepage = 'https://www.ritain.io'

  gem.metadata    = {
      'source_code_uri'   => 'https://github.com/Ritain-io/qat-web'
  }

  gem.authors = ['QAT']
  gem.license = 'GPL-3.0'

  gem.files = Dir.glob('{lib}/**/*')

  gem.required_ruby_version = '~> 3.2'

  # Development dependencies
  gem.add_development_dependency 'qat-cucumber', '~> 9.0'
  gem.add_development_dependency 'qat-devel', '~> 9.0'
  gem.add_development_dependency 'headless'
  gem.add_development_dependency 'sinatra'
  gem.add_development_dependency 'syntax'
  gem.add_development_dependency 'httparty'
  gem.add_development_dependency 'selenium-webdriver'
  gem.add_development_dependency 'webrick'

  # GEM dependencies
  gem.add_dependency 'qat-logger', '~> 9.0'
  gem.add_dependency 'little-plugger'
  gem.add_dependency 'capybara'
  gem.add_dependency 'retriable'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'gemnasium-parser'
end
