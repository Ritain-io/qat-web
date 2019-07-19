Given(/^I have accessed configuration:$/) do |table|
  QAT::Web::Configuration.last_access = table.hashes.first
end