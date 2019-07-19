Given /^no page object class( manager)? is defined$/ do |manager|
  sub_classes = if manager
                  ObjectSpace.each_object(::Class).select { |klass| klass < QAT::Web::PageManager }
                else
                  ObjectSpace.each_object(::Class).select { |klass| klass < QAT::Web::Page }
                end
  Object.class_exec do
    sub_classes.each do |klass|
      if const_defined? klass.name
        if manager
          const_get(klass.name).class_eval do
            class_variables.each do |var|
              class_variable_set var, nil
            end
          end
        end
        remove_const klass.name
      end
    end
  end
end

When /^I define a page object(?: manager)? class as:$/ do |code|
  @error = nil
  begin
    eval code
  rescue => @error
  end
end

When /^I define an empty page object class named "([^"]*)"$/ do |klass|
  @error = nil
  begin
    eval <<-RUBY
class #{klass} < QAT::Web::Page
end
    RUBY
  rescue => @error
  end
end

When /^I (?:re)?define a page object class named "([^"]*)" with code:$/ do |klass, code|
  @error = nil
  begin
    eval <<-RUBY
class #{klass} < QAT::Web::Page
#{code}
end
    RUBY
  rescue => @error
  end
end

And /^the defined values for "([^"]*)" are$/ do |klass, table|
  expected_values = table.raw.flatten.map do |entry|
    entry.dup.to_sym
  end

  eval("#{klass}.values").each do |value|
    assert expected_values.delete(value), "Unexpected value #{value} found!"
  end

  assert expected_values.empty?, "Value#{expected_values.size > 1 ? 's' : ''} '#{expected_values.join ', '}' not defined in class #{klass}"
end

Given /^I have a "([^"]*)" page instance$/ do |klass|
  @test_page = Object.const_get(klass).new
end

When /^I call the instance method "([^"]*)"$/ do |meth|
  @page_result = @test_page.send meth
end

Then /^the method returns( an instance of)? "([^"]*)"$/ do |instance, val|
  if instance
    assert_equal @page_result.class, eval(val)
  else
    assert_equal @page_result, eval(val)
  end
end

And(/^the defined actions for "([^"]*)" are$/) do |klass, table|
  expected_values = table.hashes.inject({}) do |sum, line|
    sum[line[:name].to_sym] = eval line[:returns]
    sum
  end

  eval("#{klass}.actions").each do |name, res|
    assert_equal expected_values.delete(name), res
  end

  assert expected_values.keys.empty?, "Action#{expected_values.keys.size > 1 ? 's' : ''} '#{expected_values.keys.join ', '}' not defined in class #{klass}"
end

When /^I start the page manager "([^"]*)"$/ do |klass|
  @error = nil
  begin
    @page_manager = Object.const_get(klass).new
  rescue => @error
  end
end

Then /^the current page is a "([^"]*)"$/ do |klass|
  assert @page_manager.current_page.is_a?(Object.const_get(klass)), "Expected current page to be a #{klass} but is a #{@page_manager.current_page.class.name}"
end

When /^I( try to)? use dsl method "([^"]*)"$/ do |try, method|
  if try
    begin
      @page_manager.send method
    rescue => @error
    end
  else
    @page_manager.send method
  end
end

And(/^the timeouts defined for "([^"]*)" are$/) do |klass, table|
  expected = table.hashes.first.map do |key, value|
    [key.downcase.to_sym, value.to_i]
  end.to_h

  timeouts = eval("#{klass}.timeouts")
  timeouts.each do |key, value|
    exp_value = expected.delete(key.to_sym)
    assert_equal exp_value, value, "Unexpected value '#{value}' for '#{key}' found! Expected was '#{exp_value}'!"
  end

  assert expected.empty?, "Value#{expected.size > 1 ? 's' : ''} '#{expected.values.join ', '}' not defined in class #{klass}"
end

And(/^the locators defined for "([^"]*)" are$/) do |klass, table|
  expected = table.hashes.first.map do |key, value|
    [key.downcase.to_sym, HashWithIndifferentAccess.new(eval(value))]
  end.to_h

  elements = eval("#{klass}.elements")
  elements[:locators].each do |key, value|
    exp_value = expected.delete(key.to_sym)
    assert_equal exp_value, value, "Unexpected value '#{value}' for '#{key}' found! Expected was '#{exp_value}'!"
  end

  assert expected.empty?, "Value#{expected.size > 1 ? 's' : ''} '#{expected.values.join ', '}' not defined in class #{klass}"
end

And(/^the following methods are defined for the "([^"]*)" instance$/) do |klass, table|
  expected_values = table.raw.flatten.map do |entry|
    entry.dup.to_sym
  end

  instance = eval("#{klass}.new")
  methods  = instance.public_methods(false)
  methods.each do |value|
    assert expected_values.delete(value), "Unexpected value #{value} found!"
  end

  assert expected_values.empty?, "Value#{expected_values.size > 1 ? 's' : ''} '#{expected_values.join ', '}' not defined in class #{klass}"
end