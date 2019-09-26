require 'capybara/selenium/node'

# Selenium specific implementation of the Capybara::Driver::Node API
class Capybara::Selenium::Node < Capybara::Driver::Node
  # Scrolls an element into view and return the element to allow method chaining
  #@return [Nil]
  def scroll_into_view!
    script = <<-JS
        arguments[0].scrollIntoView(false);
    JS

    driver.execute_script(script, native)
  end

  # Validates if the element on the displayed part of the pages (screen!)
  #@return [Boolean]
  def on_screen?(fully)
    raise ArgumentError, 'on_screen argument should be true or false' unless [true, false].include?(fully)

    screen_position_x = driver.execute_script('return window.scrollX;')
    screen_position_y = driver.execute_script('return window.scrollY;')

    window_size = driver.browser.manage.window.size

    screen_size_width  = window_size.width
    screen_size_height = window_size.height

    if fully
      on_screen_x = (x_origin < (screen_position_x + screen_size_width) and x_end < (screen_position_x + screen_size_width))
      on_screen_y = (y_origin < (screen_position_y + screen_size_height) and y_end < (screen_position_y + screen_size_height))
    else #partially
      on_screen_x = location.x < (screen_position_x + screen_size_width)
      on_screen_y = location.y < (screen_position_y + screen_size_height)
    end

    on_screen_x and on_screen_y
  end

  # Returns the element absolute location on the pages
  #@return [Selenium::WebDriver::Point]
  def location
    native.location
  end

  # Returns the size of this element
  # @return [Selenium::WebDriver::Dimension]
  def size
    native.size
  end

  # Returns the element X location on the pages
  #@return Integer
  def x_origin
    @x_origin ||= (location.x).to_i
  end

  # Returns the end of the X element location on the pages
  #@return Integer
  def x_end
    @x_end ||= (x_origin + size.width).to_i
  end

  # Returns the element Y location on the pages
  #@return Integer
  def y_origin
    @y_origin ||= (location.y).to_i
  end

  # Returns the end of the Y element location on the pages
  #@return Integer
  def y_end
    @y_end ||= (y_origin + size.height).to_i
  end

end