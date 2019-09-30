When(/^I navigate to home page$/) do
  browser.navigate_home!
end

Then(/^I can interact with home page$/) do
  browser.input_search "Test Automation"
end