@epic#199 @feature#268 @user_story#443 @custom_browser @sinatra_mock
Feature: User Story #443: Choose browser driver
  In order to have more flexibility in the browser configuration
  As a web test developer
  I want to be able to choose which driver to use

  @test#20
  Scenario: Create a Firefox controller from YAML with explicit driver
    Given I ask for a "custom_firefox" driver
    And an "ArgumentError" exception is raised
    And I have a "browsers" YAML file with content:
    """
    custom_firefox:
      browser: firefox
      driver: selenium
    """
    And I load drivers from the "browsers.yml" file
    When I ask for a "custom_firefox" driver
    Then no exception is raised
    And I visit "http://localhost:8090/example"
    And the web page has text "Example Domain"


  @test#23
  Scenario: Create a Chrome controller from YAML with explicit driver
    Given I ask for a "custom_chrome" driver
    And an "ArgumentError" exception is raised
    And I have a "browsers" YAML file with content:
    """
    custom_chrome:
      browser: chrome
      driver: selenium
    """
    And I load drivers from the "browsers.yml" file
    When I ask for a "custom_chrome" driver
    Then no exception is raised
    And I visit "http://localhost:8090/example"
    And the web page has text "Example Domain"
