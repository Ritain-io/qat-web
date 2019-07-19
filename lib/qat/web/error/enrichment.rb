require_relative '../configuration'
# Module to handle exception enrichment.
# Should be include in the target exception class to be enriched in runtime.
module Enrichment
  extend self

  # Enrichs an exception message with the last configuration access in QAT::Web
  #@param msg [String] exception message to be enriched
  #@return [String]
  def rich_msg(msg)
    access = QAT::Web::Configuration.last_access
    "#{msg}\nQAT::Web last access to configuration was '#{access}'"
  end
end