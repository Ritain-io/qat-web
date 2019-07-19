When /^I load virtual screen definitions$/ do
  begin
    @error = nil
    QAT::Web::Screen::Loader.load(::File.join(@tmpdir, 'screens.yml'))
  rescue => @error
  end
end

And /^I request a virtual screen( without destroying the last one)?$/ do |keep_screen|
  if keep_screen and QAT::Web::Screen::Factory.current_screen
    @old_screen_variable = QAT::Web::Screen::Factory.current_screen
    QAT::Web::Screen::Factory.instance_exec { @current_screen=nil }
  end

  begin
    @error = nil
    QAT::Web::Screen::Factory.for
  rescue => @error
  end
end

Then /^a virtual screen is( not)? created$/ do |negated|
  begin
    if negated
      refute QAT::Web::Screen::Factory.current_screen.xvfb, "Expected no virtual screen, but one was created"
    else
      refute_nil QAT::Web::Screen::Factory.current_screen.xvfb, "Expected a virtual screen, but none was created"
    end
  rescue Minitest::Assertion
    log.warn { @error } if @error
    raise
  end
end

Then /^the driver is loaded with screen "([^"]*)"$/ do |name|
  refute_nil QAT::Web::Screen::Factory.current_screen, "Expected a virtual screen, but none was created"
  assert_equal name.to_sym, QAT::Web::Screen::Factory.current_screen.name
end

And /^the current (screen|browser window) has dimensions:$/ do |type, table|
  table.hashes.each do |line|

    found = case type
              when 'screen'
                table.headers.inject({}) do |sum, header|
                  sum[header] = QAT::Web::Screen::Factory.current_screen.method(header).call
                  sum
                end
              when 'browser window'
                dim_array = case Capybara.current_driver
                              when :my_firefox
                                Capybara.current_session.driver.window_size(Capybara.current_session.driver.current_window_handle)
                              when :my_chrome
                                Capybara.current_session.driver.window_size(Capybara.current_session.driver.current_window_handle).map { |i| i+1 }
                              else
                                pending
                            end
                { 'width' => dim_array[0].to_s, 'height' => dim_array[1].to_s }
              else
                pending
            end

    table.headers.each do |property|
      assert_equal line[property], found[property], "Invalid #{property} value"
    end
  end
end

Then /^I record the virtual screen number$/ do
  @old_screen_number, @screen_number = @screen_number, ENV['DISPLAY']
end

Given /^I close the current virtual screen$/ do
  QAT::Web::Screen::Factory.current_screen.destroy
  QAT::Web::Screen::Factory.instance_exec { @current_screen=nil }
end

Then /^the virtual screen number is not the same as the old one$/ do
  log.debug { "Old screen: #{@old_screen_number}" }
  log.debug { "New screen: #{@screen_number}" }

  refute_equal @old_screen_number, @screen_number, "Expected new screen to have different number than old screen: #{@screen_number}"
end

And /^the virtual screen has the reuse option disabled$/ do
  refute QAT::Web::Screen::Factory.current_screen.xvfb.instance_exec { @reuse_display }, "Expected screen to have the reuse option disabled, but it's enabled"
end

And /^I reset the screen definition list$/ do
  QAT::Web::Screen::Loader.instance_exec do
    @screens = { default: {} }
  end
end