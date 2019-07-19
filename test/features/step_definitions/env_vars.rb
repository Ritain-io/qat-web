
Given /^I set the "([^"]*)" environment variable with value "([^"]*)"$/ do |key, value|
  override_env key, value
end

Given /^I unset the "([^"]*)" environment variable$/ do |key|
  override_env key, nil
end