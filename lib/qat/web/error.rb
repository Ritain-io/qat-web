require_relative 'version'
require_relative 'error/enrichment'

module QAT::Web
  #Basic Web error class
  #@since 1.0.0
  class Error < StandardError
    include Enrichment

    def initialize(msg=nil)
      super(rich_msg(msg))
    end
  end
end