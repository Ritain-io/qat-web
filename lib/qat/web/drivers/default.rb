module QAT::Web
  # Drivers namespace
  module Drivers
    # Module with drivers default for browsers.
    module Default
      extend self

      # Returns the default drivers for browsers
      #@return [Hash]
      def mapping
        setup_defaults unless @defaults
        @defaults
      end

      private

      # Initializes the default drivers for browsers
      #@return [Hash]
      def setup_defaults
        @defaults             ||= Hash.new(:selenium)
        @defaults[:phantomjs] = :poltergeist
      end
    end
  end
end