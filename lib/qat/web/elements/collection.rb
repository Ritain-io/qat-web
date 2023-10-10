require_relative 'base'

module QAT
  module Web
    module Elements
      # Web Element wrapper class for web elements collection
      class Collection < Base
        # Returns the collection finder block
        # @return [Proc]
        def finder
          selector = @selector
          proc do
            if selector.last.is_a?(Hash)
              all(*selector[0..1], **selector.last)
            else
              all(*selector)
            end
          end
        end
      end
    end
  end
end