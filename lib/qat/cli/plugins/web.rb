require_relative '../../web/generator'

#Plugin for CLI functions
#@since 6.1.0
module QAT
  #CLI module from QAT::Web.
  #@since 6.1.0
  module CLI
    #Plugin namespace for CLI module from QAT::Web.
    #@since 6.1.0
    module Plugins
      #Plugin for CLI functions
      #@since 6.1.0
      module Web

        #Function for adding the Logger module to a project. Just used for testing, does nothing.
        #@param stdout [IO] Stdout stream
        #@param opts [Hash] Options hash
        #@since 6.1.0
        def self.add_module stdout, opts
          QAT::Web::Generator.add_module(stdout, opts)
        end
      end
    end
  end
end