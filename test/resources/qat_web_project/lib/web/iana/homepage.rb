module WebTests
  module IANA
    class Homepage < WebTests::Page
      include QAT::Logger

      elements_config QAT.configuration.dig(:web, :iana, :homepage)

      def initialize(opts={})
        visit_page elements[:url] if opts[:force]
      end
    end
  end
end