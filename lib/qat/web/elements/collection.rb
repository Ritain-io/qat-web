require_relative 'base'

module QAT
  module Web
    module Elements
      # Web Element wrapper class for web elements collection
      class Collection < Base
        # Returns the collection finder block
        # @return [Proc]
        def finder
          proc { all(*@selector) }
        end
      end
    end
  end
end