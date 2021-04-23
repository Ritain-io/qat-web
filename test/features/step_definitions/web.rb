Given /^I (?:have|ask for) a "([^"]*)" driver$/ do |driver|

  if driver == 'rack_test'
    require_relative '../../lib/example_sinatra'
    Capybara.app = Sinatra::Application
  end

  begin
    @error = nil
    QAT::Web::Browser::Factory.for driver
  rescue => @error
  end
end

When /^I visit "([^"]*)"$/ do |site|
  Retriable.retriable(on:       [::Selenium::WebDriver::Error::WebDriverError, ::Net::ReadTimeout],
                      on_retry: (proc do |_, _, _, _|
                        driver = Capybara.current_driver
                        Capybara.current_session.reset!
                        QAT::Web::Browser::Factory.for driver
                      end)) do
    visit site
  end
end

Then /^the web page has( no)? text "([^"]*)"$/ do |negative, text|
  if negative
    assert_no_text text
  else
    assert_text text
  end
end

When /^I find the element from configuration "([^"]*)"$/ do |key|
  begin
    @error   = nil
    @element = find_from_configuration @yaml[:example][key]
  rescue => @error
    log.error <<-STRING
#{@error.exception} (#{@error.class})
#{@error.backtrace.join("\n")}
    STRING
  end
end

Then /^the element has text "([^"]*)"$/ do |text|
  @element.assert_text text
end

When /^I find an element using code:$/ do |text|
  @element = instance_eval text
end

When /^I (double|right) click the element$/ do |type|
  begin
    @element.method("#{type}_click".to_sym).call
  rescue => @error
  end
end

Then(/^last accessed configuration is$/) do |table|
  expected = table.hashes.first
  accessed = QAT::Web::Configuration.last_access
  expected = expected.symbolize_keys if expected.respond_to?(:symbolize_keys)
  accessed = accessed.symbolize_keys if accessed.respond_to?(:symbolize_keys)
  assert_equal(expected, accessed, "Configurations differ!")
end

Then(/^last accessed configuration is "([^"]*)"$/) do |value|
  expected = eval(value)
  accessed = QAT::Web::Configuration.last_access
  expected = expected.symbolize_keys if expected.respond_to?(:symbolize_keys)
  accessed = accessed.symbolize_keys if accessed.respond_to?(:symbolize_keys)
  assert_equal(expected, accessed, "Values differ!")
end


When /^I save a browser screenshot$/ do
  begin
    @screenshot_path = QAT::Web::Browser::Screenshot.take_screenshot
  rescue => @error
  end
end

Then /^I have a browser screenshot file(?: with name "([^"]*)")?$/ do |name|
  assert @screenshot_path, "Expected to have a saved screenshot path, but none was found!"
  assert ::File.exists?(@screenshot_path), "Expected to have a saved screenshot path, but none was found!"
  assert @screenshot_path.end_with? name, "Expected screenshot #{@screenshot_path} to have name #{name}" if name
end

And /^I set screenshot default name to "([^"]*)"$/ do |path|
  QAT::Web::Browser::Screenshot.screenshot_path = path
end

And /^no screenshot was saved$/ do
  refute @screenshot_path, "Expected no screenshot to be saved, but found #{@screenshot_path}"
end

And /^there is( not)? an? "([^"]*)" file attached to the HTML report with label "([^"]*)"$/ do |negative, type, label|
  report = ::File.open(::File.join 'tmp', 'aruba', 'project', 'public', 'index.html') { |f| Nokogiri::HTML(f) }
  found  = case type
           when 'png'
             report.xpath("//img[@alt='Embedded Image']")
           when 'html'
             report.xpath("//*[contains(text(),'<html>')]")
           else
             pending
           end

  if negative
    assert_empty found
  else
    assert found
  end
end

When /^I save a browser HTML dump$/ do
  begin
    @error          = nil
    @html_dump_path = QAT::Web::Browser::HTMLDump.take_html_dump
  rescue => @error
  end
end

Then /^I have a browser HTML dump file(?: with name "([^"]*)")?$/ do |name|
  @html_dump_path = (name ? name : ::File.join('public', @html_dump_path))
  assert @html_dump_path, "Expected to have a saved HTML dump path, but none was found!"
  assert ::File.exists?(@html_dump_path), "Expected to have a saved HTML dump path, but none was found!"
  assert @html_dump_path.end_with? name, "Expected HTML dump #{@html_dump_path} to have name #{name}" if name
end

And /^I set HTML dump default name to "([^"]*)"$/ do |path|
  QAT::Web::Browser::HTMLDump.html_dump_path = path
end

And /^no HTML dump was saved$/ do
  refute @html_dump_path, "Expected no HTML dump to be saved, but found #{@html_dump_path}"
end

And(/^the "([^"]*)" link with label "([^"]*)" is valid$/) do |type, label|
  aruba  = ::File.join 'tmp', 'aruba', 'project', 'public'
  report = ::File.open(::File.join aruba, 'index.html') { |f| Nokogiri::HTML(f) }
  src    = case type
           when 'png'
             report.at_xpath("//span[@class='embed']/a[text()='#{label}']/../img[contains(@src, '.#{type}')]")['src']
           when 'html'
             report.at_xpath("//span[@class='embed']/a[text()='#{label}'][contains(@href, '.#{type}')]")['href']
           else
             pending
           end
  assert ::File.file?(::File.join(aruba, src))
end

When /^I switch to iframe "([^"]*)"$/ do |name|
  switch_to_frame find(:frame, name)
end

When /^I switch back from iframe$/ do
  switch_to_frame(:parent)
end

When /^I switch to top frame$/ do
  switch_to_frame(:top)
end

When(/^the title element is scrolled into view( and click it)?$/) do |click|
  if click
    @element.scroll_into_view!.click
  else
    @element.scroll_into_view!
  end
end


And(/^the (image|title) element is (not|fully|partially) on screen$/) do |element, view|

  if element == 'title'
    @element = find(:xpath, '//h1')
  else
    @element = find(:xpath, '//img')
  end

  case view
    when 'fully'
      assert @element.on_screen?(fully: true)
    when 'partially'
      assert @element.on_screen?(fully: false)
    else
      refute @element.on_screen?
  end

end


When(/^the element is scrolled into view( and click it)?$/) do |click|
  if click
    @element.scroll_into_view!.click
  else
    @element.scroll_into_view!
  end
end