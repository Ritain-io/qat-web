require_relative 'loader'

module QAT
  module Web
    module Browser
      # Helper methods for configuration auto-loading
      module AutoLoad
        include QAT::Logger

        # Loads all screens from QAT cconfiguration cache
        def self.load_browsers!
          if QAT.respond_to?(:configuration) && QAT.configuration[:browsers]
            QAT::Web::Browser::Loader.load_config(QAT.configuration[:browsers])
            log.debug { "Browser controllers loaded in cache: [#{Capybara.drivers.keys.join(', ')}]" }
          else
            log.debug { "Browser controllers aren't loaded in cache, load screens manually from file using QAT::Web::Browser::Loader#load" }
          end
        end
      end
    end
  end
end