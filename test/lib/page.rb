require 'qat/web'

class Page
  include QAT::Web::Finders
  attr_reader :config

  def initialize(config)
    @config = config.deep_symbolize_keys
  end

  def goto
    page.visit config[:url]
  end

  def title
    find_from_configuration config[:title]
  end
end