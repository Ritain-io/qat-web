require 'capybara/node/element'

# Capybara namespace
module Capybara
  # Capybara::Node namespace
  module Node
    # Capybara::Node::Element namespace
    class Element < Base
      # Scrolls an element into view and return the element to allow method chaining
      #@return [Capybara::Node::Element]
      def scroll_into_view!
        synchronize { base.scroll_into_view! }
        self
      end

      # Validates if the element on the displayed part of the page (screen!)
      #@return [Boolean]
      def on_screen?(fully: false)
        synchronize { base.on_screen?(fully) }
      end

      # Returns the element absolute location on the page
      #@return [Selenium::WebDriver::Point]
      def location
        synchronize { base.location }
      end

      # Returns the size of this element
      # @return [Selenium::WebDriver::Dimension]
      def size
        synchronize { base.size }
      end
    end
  end
end