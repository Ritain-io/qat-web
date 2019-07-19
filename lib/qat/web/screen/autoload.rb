require_relative 'loader'

module QAT
  module Web
    module Screen
      # Helper methods for configuration auto-loading
      module AutoLoad
        include QAT::Logger

        # Loads all screens from QAT cconfiguration cache
        def self.load_screens!
          if QAT.respond_to?(:configuration) && QAT.configuration[:screens]
            QAT::Web::Screen::Loader.load_config(QAT.configuration[:screens])
            log.debug { "Screens loaded in cache: [#{QAT::Web::Screen::Loader.screens.keys.join(', ')}]" }
          else
            log.debug { "Screens aren't loaded in cache, load screens manually from file using QAT::Web::Screen::Loader#load" }
          end
        end
      end
    end
  end
end