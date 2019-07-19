When(/^I have a Web implementation of the Example web page$/) do
  @example_page = ExamplePage.new(@yaml)
end

And(/^I visit the Example web page$/) do

  Retriable.retriable(on: [::Selenium::WebDriver::Error::WebDriverError, ::Net::ReadTimeout],
                      on_retry:(proc do |_, _, _, _|
                        driver = Capybara.current_driver
                        Capybara.current_session.reset!
                        QAT::Web::Browser::Factory.for driver
                      end)) do
    @example_page.goto
  end
end

And(/^the Example page title has text "([^"]*)"$/) do |text|
  @example_page.title.assert_text(text)
end

Then(/^Example page last accessed configuration is$/) do |table|
  expected = table.hashes.first
  accessed = @example_page.last_access
  expected = expected.symbolize_keys if expected.respond_to?(:symbolize_keys)
  accessed = accessed.symbolize_keys if accessed.respond_to?(:symbolize_keys)
  assert_equal(expected, accessed, "Configurations differ!")
end

Then(/^Example page last accessed configuration is "([^"]*)"$/) do |value|
  expected = eval(value)
  accessed = @example_page.last_access
  expected = expected.symbolize_keys if expected.respond_to?(:symbolize_keys)
  accessed = accessed.symbolize_keys if accessed.respond_to?(:symbolize_keys)
  assert_equal(expected, accessed, "Values differ!")
end