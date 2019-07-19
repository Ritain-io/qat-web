When /^I visit "([^"]*)"$/ do |site|
  visit site
end

Then /^the web page has text "([^"]*)"$/ do |text|
  assert_text text
end

Given /^false$/ do
  assert false
end

When(/^a QAT::Web::Error exception is raised with message "([^"]*)"$/) do |message|
  raise QAT::Web::Error.new message
end
