Then /^an? "([^"]*)" exception is raised$/ do |klass|
  refute_nil @error, "Expected a #{klass} exception to have occured, but none was found"
  log.debug @error
  assert_equal klass, @error.class.to_s
end

Then /^no exception is raised$/ do
  message = "Expected no exception but found a #{@error.class}"
  message << " (#{@error.message})\n#{@error.backtrace.join("\n")}" if @error.respond_to?(:message)
  refute @error, message
end

Then(/^the enriched exception message should have text:$/) do |text|
  assert_equal(text.gsub(/^\s*/, ''), @error.message, "Messages differ!")
end

Then(/^the exception message (is|contains) "([^"]*)"$/) do |matcher, text|
  case matcher
    when 'is'
      assert_equal text, @error.message
    when 'contains'
      assert @error.message.match(/#{text}/)
  end

end

When(/^a QAT::Web::Error exception is raised with message "([^"]*)"$/) do |message|
  begin
    @error = nil
    raise QAT::Web::Error.new message
  rescue => @error
  end
end

When(/^a Capybara::CapybaraError exception is raised with message "([^"]*)"$/) do |message|
  begin
    @error = nil
    raise Capybara::CapybaraError.new message
  rescue => @error
  end
end