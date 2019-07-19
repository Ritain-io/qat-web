require_relative 'base'

module QAT
  module Web
    module Elements
      # Web Element wrapper class for a web element
      class Element < Base
        # Returns the element finder block
        # @return [Proc]
        def finder
          proc { find(*@selector) }
        end
      end
    end
  end
end