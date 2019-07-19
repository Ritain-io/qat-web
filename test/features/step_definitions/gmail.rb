When(/^I have a Web implementation of the Gmail web page$/) do
  @gmail = GmailPage.new(@yaml)
end

And(/^I visit the Gmail web page$/) do
  @gmail.goto
end

And(/^the Gmail page title has text "([^"]*)"$/) do |text|
  @gmail.title.assert_text(text)
end

Then(/^Gmail page last accessed configuration is$/) do |table|
  expected = table.hashes.first
  accessed = @gmail.last_access
  expected = expected.symbolize_keys if expected.respond_to?(:symbolize_keys)
  accessed = accessed.symbolize_keys if accessed.respond_to?(:symbolize_keys)
  assert_equal(expected, accessed, "Configurations differ!")
end

Then(/^Gmail page last accessed configuration is "([^"]*)"$/) do |value|
  expected = eval(value)
  accessed = @gmail.last_access
  expected = expected.symbolize_keys if expected.respond_to?(:symbolize_keys)
  accessed = accessed.symbolize_keys if accessed.respond_to?(:symbolize_keys)
  assert_equal(expected, accessed, "Values differ!")
end