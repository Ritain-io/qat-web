require_relative 'base'

module QAT
  module Web
    module Elements
      # Web Element wrapper class for a web element
      class Element < Base
        # Returns the element finder block
        # @return [Proc]
        def finder
          selector = @selector
          proc do
            if selector.last.is_a?(Hash)
              find(*selector[0..1], **selector.last)
            else
              find(*selector)
            end
          end
        end
      end
    end
  end
end