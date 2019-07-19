Given(/^I visit the Example website$/) do
  browser.goto_example!
end

Then(/^the header contains text:$/) do |text|
  assert_equal(text.strip, browser.header_text.strip)
end

When(/^I click the more information link$/) do
  browser.click_more_info!
end

Then(/^the first body paragraph contains text:$/) do |text|
  assert_equal(text.strip, browser.body_text.strip)
end