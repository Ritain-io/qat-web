@epic#199 @feature#268 @user_story#460 @sinatra_mock
Feature: User Story #460: Browser Controller for Chrome
  In order to to do tests in various browsers
  As a web tester
  I want to have a browser controller for Chrome

  @selenium_headless @test#66
  Scenario: Ask for a web driver
    Given I have a "chrome" driver
    When I visit "http://localhost:8090/example"
    Then the web page has text "Example Domain"

  @test#25
  Scenario: Create a Chrome driver from YAML
    Given I ask for a "my_chrome" driver
    And an "ArgumentError" exception is raised
    And I have a "browsers" YAML file with content:
    """
    my_chrome:
      browser: chrome
    """
    And I load drivers from the "browsers.yml" file
    When I ask for a "my_chrome" driver
    Then no exception is raised
    And I visit "http://localhost:8090/example"
    And the web page has text "Example Domain"