[![Build Status](https://travis-ci.org/readiness-it/qat-web.svg?branch=master)](https://travis-ci.org/readiness-it/qat-web)

# QAT::Web

- Welcome to the QAT Web gem!


## Table of contents 
- This gem is a browser controller for Web testing, with support for various browsers and webdrivers that could be used in the following ways:
  - **Bug Reports with HTML Dump & Screenshots**
  - **Easier planning and Implementation of web interaction using Page Objects**


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qat-web'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install qat-web

## Some Usage Examples:

Screen Capture:
````ruby
QAT::Web::Browser::Screenshot.take_screenshot, 'image/png', 'Screenshot'
````

Generate HTML Dump:
````ruby
QAT::Web::Browser::HTMLDump.take_html_dump, 'text/plain', 'HTML dump'
````

Create Browser Display: 
````ruby
driver = Capybara.current_driver
QAT::Web::Browser::Factory.for driver
````

Create browser from yaml file:
````yaml
my_firefox:
  browser: firefox
  screen: my_screen
````

Configure virtual screen from screens.yml file:
````yaml
my_screen:
  resolution:
    width: <width>
    height: <height>
    depth: 24
````

Get details of last configuration value used:
````ruby
QAT::Web::Configuration.last_access
````

Get page url after a failed scenario:
````ruby
 QAT::Web::Browser.print_url 
````

Raise exception:
````ruby
raise QAT::Web::Error.new message
````

Load selectors from a page example yml file: 
````yaml
url: http://example.com

locators:
  element_name:
    xpath: //div/h1 #DOM path to required element
    wait: 2 #Waits until 5 seconds for element to be present
    visible: true #Indicates if element is visble or not in the window
    
````

Load timeouts from timeouts.yml file: 
````yaml
browser:
  small: 5
  medium: 15
  big: 30
  huge: 60
  go_grab_a_coffee: 120
  bathroom_break: 360
  
#Example of timeouts use: 
locators:
  element_name:
    xpath: //div/h1 
    wait: timeouts.browser.small 
````

Page Object:
````ruby
module My_Module
  class My_Web_Page < My_Module::Page
    include QAT::Logger

    elements_config QAT.configuration.dig(:web, :web_page, :page)

    web_element :element_name

    def initialize()
      visit_page elements[:url] 
    end

    get_value :element_name_text do
      log.info "Getting element_name text..." 
      element_name.text 
    end
    
    def click_element_name
      log.debug "Clicking on element_name..."
      element_name.click
    end
  end
end
````

Create Browser Profile:
````ruby
create_profile (driver, browser, properties, addons)
````

Set properties to a Profile:
````ruby
selenium_firefox_profile(properties, addons)
````

Verify Elements on a Page with selector:
````ruby
has_selector? *selector_page_element
has_no_selector? *selector_page_element
````

To start browser set the environment variable:
````
QAT_DISPLAY: none
````

# Documentation

- [API documentation](https://readiness-it.github.io/qat-web/)

## Capybara

To know more information about this gem, please check also the [capybara documentation](https://www.rubydoc.info/github/jnicklas/capybara/Capybara).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/readiness-it/qat-web. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the QAT::Web project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/readiness-it/qat-web/blob/master/CODE_OF_CONDUCT.md).
